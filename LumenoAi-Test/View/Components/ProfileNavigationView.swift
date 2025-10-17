//
//  ProfileNavigationView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct ProfileNavigationView: View {
    let user: User?
    let isCurrentUser: Bool
    let isScrolled: Bool
    let onBackTap: () -> Void
    let onImageTap: () -> Void
    
    private var displayName: String {
        user?.name.fullNameWithTitle ?? "Unknown User"
    }
    
    private var displayImage: ImageResource {
        .avatarEx
    }
    
    private var displayImageURL: String? {
        user?.picture.large
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Custom back button - only show if not current user
                if !isCurrentUser {
                    Button(action: onBackTap) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 30, height: 40)
                    }
                    .buttonStyle(.glass)
                }
                
                // Compact header content when scrolled
                if isScrolled {
                    if let imageURL = displayImageURL {
                        AsyncProfileImage(
                            imageURL: imageURL,
                            size: 35,
                            fallbackImage: displayImage
                        )
                        .onTapGesture {
                            onImageTap()
                        }
                    } else {
                        Image(displayImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .onTapGesture {
                                onImageTap()
                            }
                    }
                    
                    Text(displayName)
                        .font(.headline)
                        .bold()
                }
                
                Spacer()
                
                // Follow/Edit button when scrolled
                if isScrolled {
                    Button(action: {
                        
                    }) {
                        Text(isCurrentUser ? "Edit" : "Follow")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(isCurrentUser ? Color.gray : Color.blue)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .background(
                Color(.systemBackground)
                    .opacity(isScrolled ? 1 : 0)
            )
            .animation(.easeInOut(duration: 0.3), value: isScrolled)
            
            Spacer()
        }
    }
}

#Preview {
    ProfileNavigationView(
        user: nil,
        isCurrentUser: false,
        isScrolled: false,
        onBackTap: {},
        onImageTap: {}
    )
}
