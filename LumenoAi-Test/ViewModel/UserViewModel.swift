//
//  UserViewModel.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://randomuser.me/api/"
    
    init() {
        Task {
            await fetchUsers()
        }
    }
    
    func fetchUsers(results: Int = 50) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let url = URL(string: "\(baseURL)?results=\(results)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(UserResponse.self, from: data)
            
            self.users = response.results
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to fetch users: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    func refreshUsers() async {
        await fetchUsers()
    }
    
    func loadMoreUsers() async {
        await fetchUsers(results: 20)
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
