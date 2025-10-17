//
//  ProfileNameSection.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct ProfileNameSection: View {
    let user: User?
    let isCurrentUser: Bool
    let isScrolled: Bool
    
    private var displayName: String {
        user?.name.fullNameWithTitle ?? "Unknown User"
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 200)
                .opacity(0)
            
            HStack {
                Text(displayName)
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 10)
                
                Spacer()
                
                Button(action: {
                    // Action for follow/edit
                }) {
                    Text(isCurrentUser ? "Edit Profile" : "Follow")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(isCurrentUser ? Color.gray : Color.blue)
                        .clipShape(Capsule())
                }
                .opacity(isScrolled ? 0 : 1)
                .animation(.easeInOut(duration: 0.3), value: isScrolled)
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    ProfileNameSection(
        user: nil,
        isCurrentUser: false,
        isScrolled: false
    )
}
