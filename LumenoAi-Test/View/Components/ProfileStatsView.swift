//
//  ProfileStatsView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct ProfileStatsView: View {
    var body: some View {
        HStack {
            VStack {
                Text("Followers")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                Text("123")
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.thinMaterial))
            
            VStack {
                Text("Following")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                Text("456")
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.thinMaterial))
        }
        .padding(.vertical)
    }
}

#Preview {
    ProfileStatsView()
}
