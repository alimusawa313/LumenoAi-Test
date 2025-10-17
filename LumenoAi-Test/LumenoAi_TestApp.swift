//
//  LumenoAi_TestApp.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI
import SwiftData
import BackgroundTasks

@main
struct LumenoAi_TestApp: App {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(authManager)
                .onAppear {
                    // Register background tasks when app launches
                    userViewModel.registerBackgroundTask()
                }
        }
    }
}
