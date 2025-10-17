//
//  ContentView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationStack {
            ZStack {
                if authManager.isAuthenticated {
                    MainAppView()
                        .transition(.move(edge: .trailing))
                        .zIndex(1)
                } else {
                    LoginView()
                        .transition(.move(edge: .leading))
                        .zIndex(0)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authManager.isAuthenticated)
            .id(authManager.isAuthenticated) 
        }
    }
}

struct MainAppView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeListView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("My Profile")
                }
                .tag(1)
        }
        .navigationBarHidden(true)
        .onAppear {
            selectedTab = 0
            
            if userViewModel.users.isEmpty && !userViewModel.isLoading {
                Task {
                    await userViewModel.fetchUsers()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
        .environmentObject(UserViewModel())
}
