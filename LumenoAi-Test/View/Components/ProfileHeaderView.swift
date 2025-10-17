//
//  ProfileHeaderView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    let user: User?
    let isCurrentUser: Bool
    let isScrolled: Bool
    let scrollOffset: CGFloat
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
        ZStack {
            VStack {
                ZStack {
                    if let imageURL = displayImageURL {
                        AsyncImage(url: URL(string: imageURL)) { phase in
                            switch phase {
                            case .empty:
                                Image(displayImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                Image(displayImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            @unknown default:
                                Image(displayImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                        .frame(height: isScrolled ? 0 : max(300 - scrollOffset, 100))
                        .opacity(isScrolled ? 0 : 1)
                        .clipped()
                        .animation(.easeInOut(duration: 0.3), value: isScrolled)
                        .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                        .onTapGesture {
                            onImageTap()
                        }
                    } else {
                        Image(displayImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: isScrolled ? 0 : max(300 - scrollOffset, 100))
                            .opacity(isScrolled ? 0 : 1)
                            .clipped()
                            .animation(.easeInOut(duration: 0.3), value: isScrolled)
                            .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                            .onTapGesture {
                                onImageTap()
                            }
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: isScrolled ? 0 : 150)
                            .opacity(isScrolled ? 0 : 1)
                            .foregroundStyle(LinearGradient(colors: [.clear, Color(.systemBackground), Color(.systemBackground)], startPoint: .top, endPoint: .bottom))
                            .allowsHitTesting(false)
                            .animation(.easeInOut(duration: 0.8), value: isScrolled)
                            .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                            .padding(.bottom, -10)
                    }
                }
                .frame(height: isScrolled ? 0 : max(300 - scrollOffset, 100))
                .clipped()
                .animation(.easeInOut(duration: 0.3), value: isScrolled)
                .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                
                Spacer()
            }
            
        }
    }
}

#Preview {
    ProfileHeaderView(
        user: nil,
        isCurrentUser: false,
        isScrolled: false,
        scrollOffset: 0,
        onImageTap: {}
    )
}
