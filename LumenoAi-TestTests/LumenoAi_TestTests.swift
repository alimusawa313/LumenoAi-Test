//
//  LumenoAi_TestTests.swift
//  LumenoAi-TestTests
//
//  Created by Ali Haidar on 10/17/25.
//

import Testing
import Foundation
@testable import LumenoAi_Test

struct LumenoAi_TestTests {

    // MARK: - AuthManager Tests
    
    @Test @MainActor func testAuthManagerInitialization() async {
        let authManager = AuthManager()
        
        #expect(authManager.isAuthenticated == false)
        #expect(authManager.currentUser == nil)
        #expect(authManager.isLoading == false)
        #expect(authManager.errorMessage == nil)
    }
    
    @Test @MainActor func testAuthManagerLogout() async {
        let authManager = AuthManager()
        
        // Test logout functionality
        authManager.logout()
        
        #expect(authManager.isAuthenticated == false)
        #expect(authManager.currentUser == nil)
    }
    
    @Test @MainActor func testAuthManagerLoginWithRandomUser() async throws {
        let authManager = AuthManager()
        
        // Test login with random user
        await authManager.loginWithRandomUser()
        
        // Wait a bit for async operation
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Verify authentication state
        #expect(authManager.isAuthenticated == true)
        #expect(authManager.currentUser != nil)
        #expect(authManager.isLoading == false)
    }
    
    // MARK: - UserViewModel Tests
    
    @Test @MainActor func testUserViewModelInitialization() async {
        let userViewModel = UserViewModel()
        
        #expect(userViewModel.users.isEmpty)
        #expect(userViewModel.isLoading == false)
        #expect(userViewModel.errorMessage == nil)
    }
    
    @Test @MainActor func testUserViewModelFetchUsers() async throws {
        let userViewModel = UserViewModel()
        
        // Test fetching users
        await userViewModel.fetchUsers(results: 5)
        
        // Wait for async operation
        try await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
        
        // Verify users were fetched
        #expect(userViewModel.users.count > 0)
        #expect(userViewModel.isLoading == false)
    }
    
    @Test @MainActor func testUserViewModelClearCache() async {
        let userViewModel = UserViewModel()
        
        // Test cache clearing
        userViewModel.clearCache()
        
        #expect(userViewModel.users.isEmpty)
    }
    
    // MARK: - Model Tests
    
    @Test func testUserResponseDecoding() throws {
        let jsonString = """
        {
            "results": [
                {
                    "gender": "male",
                    "name": {
                        "title": "Mr",
                        "first": "John",
                        "last": "Doe"
                    },
                    "location": {
                        "street": {
                            "number": 123,
                            "name": "Main St"
                        },
                        "city": "New York",
                        "state": "NY",
                        "country": "United States",
                        "postcode": "10001",
                        "coordinates": {
                            "latitude": "40.7128",
                            "longitude": "-74.0060"
                        },
                        "timezone": {
                            "offset": "-5:00",
                            "description": "Eastern Time"
                        }
                    },
                    "email": "john.doe@example.com",
                    "login": {
                        "uuid": "123e4567-e89b-12d3-a456-426614174000",
                        "username": "johndoe",
                        "password": "password123",
                        "salt": "salt123",
                        "md5": "md5hash",
                        "sha1": "sha1hash",
                        "sha256": "sha256hash"
                    },
                    "dob": {
                        "date": "1990-01-01T00:00:00.000Z",
                        "age": 34
                    },
                    "registered": {
                        "date": "2020-01-01T00:00:00.000Z",
                        "age": 4
                    },
                    "phone": "555-1234",
                    "cell": "555-5678",
                    "id": {
                        "name": "SSN",
                        "value": "123-45-6789"
                    },
                    "picture": {
                        "large": "https://example.com/large.jpg",
                        "medium": "https://example.com/medium.jpg",
                        "thumbnail": "https://example.com/thumb.jpg"
                    },
                    "nat": "US"
                }
            ],
            "info": {
                "seed": "testseed",
                "results": 1,
                "page": 1,
                "version": "1.4"
            }
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let userResponse = try decoder.decode(UserResponse.self, from: jsonData)
        
        #expect(userResponse.results.count == 1)
        #expect(userResponse.results.first?.name.first == "John")
        #expect(userResponse.results.first?.name.last == "Doe")
        #expect(userResponse.results.first?.email == "john.doe@example.com")
        #expect(userResponse.info.results == 1)
    }
    
    @Test func testNameFullNameComputedProperty() {
        let name = Name(title: "Mr", first: "John", last: "Doe")
        
        #expect(name.fullName == "John Doe")
        #expect(name.fullNameWithTitle == "Mr John Doe")
    }
    
    

}
