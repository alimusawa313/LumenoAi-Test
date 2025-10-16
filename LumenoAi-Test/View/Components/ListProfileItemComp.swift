//
//  ListProfileItemComp.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct ListProfileItemComp: View {
    
    
    var imgSize: CGFloat = 80
    var imageName: ImageResource
    var name: String
    var email: String
    //    @EnvironmentObject var router: Router
    
    var body: some View {
        HStack(spacing: 15) {
            Image(imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .shadow(radius: 3, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(.thinMaterial))
//        .onTapGesture {
        
//        }
    }
}

#Preview {
    ListProfileItemComp(imageName: .avatarEx,
                        name: "John Doe",
                        email: "johndoe@email.com",
    )
}
