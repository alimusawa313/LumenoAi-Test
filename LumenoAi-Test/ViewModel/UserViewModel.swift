//
//  UserViewModel.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI
import Foundation
import Combine
import BackgroundTasks

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://randomuser.me/api/"
    private let cacheKey = "cached_users"
    private let maxRetryAttempts = 3
    private let retryDelay: TimeInterval = 2.0
    
    // Performance optimization flags
    private let isDebugMode = _isDebugAssertConfiguration()
    private let shouldUseOptimizedNetworking = true
    
    init() {
        Task {
            await loadCachedUsers()
        }
    }
    
    private func loadCachedUsers() async {
        // Load cache on background queue
        let cachedUsers: [User]? = await Task.detached(priority: .utility) {
            guard let cachedData = UserDefaults.standard.data(forKey: self.cacheKey) else {
                return nil
            }
            return try? JSONDecoder().decode([User].self, from: cachedData)
        }.value
        
        // Update UI on main actor
        await MainActor.run {
            if let cachedUsers = cachedUsers {
                self.users = cachedUsers
            } else {
                // If no cache, fetch from API
                Task {
                    await self.fetchUsers()
                }
            }
        }
    }
    
    private func saveUsersToCache() {
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }
    
    func fetchUsers(results: Int = 50) async {
        await fetchUsersWithRetry(results: results, attempt: 1)
    }
    
    private func fetchUsersWithRetry(results: Int, attempt: Int) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            // Perform network request on background queue with optimized configuration
            let (data, response) = try await Task.detached(priority: .userInitiated) {
                let url = URL(string: "\(self.baseURL)?results=\(results)")!
                
                // Use optimized URLSession configuration for better performance
                let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = 10.0
                config.timeoutIntervalForResource = 30.0
                config.waitsForConnectivity = false
                config.allowsCellularAccess = true
                
                let session = URLSession(configuration: config)
                return try await session.data(from: url)
            }.value
            
            // Validate response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            // Decode response (perform on the current actor to respect any MainActor-isolated model types)
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(UserResponse.self, from: data)
            
            // Update UI on main actor with performance optimization
            await MainActor.run {
                // Batch UI updates to reduce redraws
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.users = decodedResponse.results
                }
                self.isLoading = false
            }
            
            // Save to cache on background queue
            await Task.detached(priority: .utility) {
                await MainActor.run {
                    self.saveUsersToCache()
                }
            }.value
            
        } catch {
            // Retry logic
            if attempt < maxRetryAttempts {
                do {
                    try await Task.sleep(nanoseconds: UInt64(retryDelay * Double(attempt) * 1_000_000_000))
                    await fetchUsersWithRetry(results: results, attempt: attempt + 1)
                } catch {
                    // If sleep fails (task cancelled), stop retrying
                    await MainActor.run {
                        self.errorMessage = "Request cancelled: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                }
            } else {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch users after \(maxRetryAttempts) attempts: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func refreshUsers() async {
        await fetchUsers()
    }
    
    func loadMoreUsers() async {
        await fetchUsers(results: 20)
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
        users = []
    }
    
    // MARK: - Background Task Handling
    
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.lumenoai.refresh-users", using: nil) { task in
            self.handleBackgroundRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    private func handleBackgroundRefresh(task: BGAppRefreshTask) {
        // Schedule the next background refresh
        scheduleBackgroundRefresh()
        
        // Perform background fetch
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        Task {
            await fetchUsers(results: 20) // Fetch fewer users in background
            // Check if the fetch was successful by checking if we have users
            await MainActor.run {
                task.setTaskCompleted(success: !self.users.isEmpty)
            }
        }
    }
    
    private func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.lumenoai.refresh-users")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background refresh: \(error)")
        }
    }
}

// MARK: - Helper Extensions
extension User {
    var honeycombPosition: HoneycombPosition {
        let colors: [Color] = [
            .blue.opacity(0.3),
            .pink.opacity(0.3),
            .purple.opacity(0.3),
            .orange.opacity(0.3),
            .green.opacity(0.3),
            .teal.opacity(0.3),
            .mint.opacity(0.3),
            .indigo.opacity(0.3),
            .cyan.opacity(0.3),
            .yellow.opacity(0.3),
            .red.opacity(0.3),
            .brown.opacity(0.3)
        ]
        
        let colorIndex = abs(name.first.hashValue) % colors.count
        let backgroundColor = colors[colorIndex]
        
        return HoneycombPosition(
            offset: CGSize.zero, // Will be calculated in HomeListView
            imageName: .avatarEx, // Fallback image
            imageURL: picture.thumbnail, // API image URL
            name: name.fullName,
            username: login.username,
            backgroundColor: backgroundColor,
            user: self
        )
    }
}

