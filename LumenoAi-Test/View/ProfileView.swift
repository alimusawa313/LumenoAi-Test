//
//  ProfileView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    @State private var selectedTab = "info"
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolled: Bool = false
    @State private var showFullScreenImage: Bool = false
    @State private var showingLogoutAlert = false
    
    let profileUser: User?
    let isCurrentUser: Bool
    
    init(user: User? = nil, isCurrentUser: Bool = true) {
        self.profileUser = user
        self.isCurrentUser = isCurrentUser
    }
    
    var user: User? {
        profileUser ?? authManager.currentUser
    }
    
    private let scrollThreshold: CGFloat = 80
    
    private var displayImage: ImageResource {
        .avatarEx
    }
    
    private var displayImageURL: String? {
        user?.picture.large
    }
    
    var body: some View {
        ZStack {
            ProfileHeaderView(
                user: user,
                isCurrentUser: isCurrentUser,
                isScrolled: isScrolled,
                scrollOffset: scrollOffset,
                onImageTap: {
                    showFullScreenImage = true
                }
            )
            
            ScrollView {
                VStack(spacing: 0) {
                    ProfileNameSection(
                        user: user,
                        isCurrentUser: isCurrentUser,
                        isScrolled: isScrolled
                    )
                    
                    ProfileStatsView()
                    
                    if isCurrentUser {
                        VStack(spacing: 12) {
                            Button("Generate New Random User") {
                                Task {
                                    await authManager.loginWithRandomUser()
                                }
                            }
                            .buttonSizing(.flexible)
                            .buttonStyle(.glassProminent)
                            
                            Button("Logout") {
                                showingLogoutAlert = true
                            }
                            .buttonSizing(.flexible)
                            .buttonStyle(.glass)
                            .foregroundColor(.red)
                        }
                        .padding(.bottom)
                    }
                    
                    Picker("Select Tab", selection: $selectedTab) {
                        Text("Info").tag("info")
                        Text("Location").tag("location")
                    }
                    .pickerStyle(.segmented)
                    
                    if selectedTab == "info" {
                        ProfileInfoView(user: user)
                    } else {
                        ProfileLocationView(user: user)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                scrollOffset = 0
                            }
                            .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
                                let offset = max(0, -newValue)
                                scrollOffset = offset
                                isScrolled = offset > scrollThreshold
                            }
                    }
                )
            }
            
            ProfileNavigationView(
                user: user,
                isCurrentUser: isCurrentUser,
                isScrolled: isScrolled,
                onBackTap: {
                    if !isCurrentUser {
                        dismiss()
                    }
                },
                onImageTap: {
                    showFullScreenImage = true
                }
            )
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $showFullScreenImage) {
            ImageFullScreenView(
                imageURL: displayImageURL,
                fallbackImage: displayImage
            )
        }
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    authManager.logout()
                }
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

#Preview("Current User") {
    ProfileView()
        .environmentObject(AuthManager())
}
