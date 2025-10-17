//
//  ProfileInfoView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct ProfileInfoView: View {
    let user: User?
    
    private var displayName: String {
        user?.name.fullNameWithTitle ?? "Unknown User"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            InfoField(label: "name", value: displayName)
            InfoField(label: "username", value: user?.login.username ?? "N/A")
            InfoField(label: "email", value: user?.email ?? "N/A")
            InfoField(label: "gender", value: user?.gender.capitalized ?? "N/A")
            InfoField(label: "phone", value: user?.phone ?? "N/A")
            InfoField(label: "cell", value: user?.cell ?? "N/A")
        }
        .padding(.top)
    }
}

struct InfoField: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .foregroundStyle(.secondary)
                .font(.caption)
            
            Text(value)
                .bold()
            HStack { Spacer() }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
    }
}

#Preview {
    ProfileInfoView(user: nil)
}
