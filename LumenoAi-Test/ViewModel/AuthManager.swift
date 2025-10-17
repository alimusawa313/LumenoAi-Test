//
//  AuthManager.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://randomuser.me/api/"
    private let userDefaultsKey = "current_user"
    private let isAuthenticatedKey = "is_authenticated"
    
    init() {
        loadSavedUser()
    }
    
    private func loadSavedUser() {
        // Check if user is already authenticated
        isAuthenticated = UserDefaults.standard.bool(forKey: isAuthenticatedKey)
        
        // Load saved user data
        if let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
        }
    }
    
    func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch a random user from the API
            let url = URL(string: "\(baseURL)?results=1")!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let userResponse = try decoder.decode(UserResponse.self, from: data)
            
            guard let user = userResponse.results.first else {
                throw URLError(.cannotParseResponse)
            }
            
            // Simulate login validation (in a real app, you'd validate against a server)
            // For demo purposes, we'll accept any username/password and use the random user
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
                self.saveUser(user)
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Login failed: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func loginWithRandomUser() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch a random user from the API
            let url = URL(string: "\(baseURL)?results=1")!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let userResponse = try decoder.decode(UserResponse.self, from: data)
            
            guard let user = userResponse.results.first else {
                throw URLError(.cannotParseResponse)
            }
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
                self.saveUser(user)
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Login failed: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.set(false, forKey: isAuthenticatedKey)
    }
    
    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            UserDefaults.standard.set(true, forKey: isAuthenticatedKey)
        }
    }
}
