//
//  CircleProfileComp.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct CircleProfileComp: View {
    
    var imgSize: CGFloat = 80
    var imageName: ImageResource
    var imageURL: String?
    var name: String
    var email: String
    //    @State private var isExpanding: Bool = false
    @Binding var isExpanding: Bool
    //    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(alignment: .center){
            if let imageURL = imageURL {
                AsyncProfileImage(
                    imageURL: imageURL,
                    size: imgSize,
                    fallbackImage: imageName
                )
                .shadow(radius: 5, x: 0, y: 2)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanding.toggle()
                    }
                }
            } else {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imgSize, height: imgSize)
                    .clipShape(Circle())
                    .shadow(radius: 5, x: 0, y: 2)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isExpanding.toggle()
                        }
                    }
            }
            
            if isExpanding{
                VStack(alignment: .center, spacing: 8){
                    Text(name)
                        .bold()
                        .foregroundStyle(.primary)
                    Text("\(email)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Button("View Profile"){
                    }
                    .buttonStyle(.glassProminent)
                    
                }
                .padding(.trailing, 5)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 0.8).combined(with: .opacity)
                ))
            }
        }
        .padding(isExpanding ? 15 : 0)
        .background(
            RoundedRectangle(cornerRadius: isExpanding ? 20 : 200)
                .foregroundStyle(.thinMaterial)
        )
        .shadow(radius: isExpanding ? 5 : 0, y: isExpanding ? 2 : 0)
        .compositingGroup()
    }
}

#Preview {
    CircleProfileComp(
        imageName: .avatarEx,
        imageURL: "https://randomuser.me/api/portraits/thumb/men/75.jpg",
        name: "John Doe",
        email: "johndoe@email.com",
        isExpanding: .constant(true)
    )
}
