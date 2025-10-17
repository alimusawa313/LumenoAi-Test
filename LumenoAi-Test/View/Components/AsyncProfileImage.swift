//
//  AsyncProfileImage.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct AsyncProfileImage: View {
    let imageURL: String
    let size: CGFloat
    let fallbackImage: ImageResource
    
    init(imageURL: String, size: CGFloat, fallbackImage: ImageResource = .avatarEx) {
        self.imageURL = imageURL
        self.size = size
        self.fallbackImage = fallbackImage
    }
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(fallbackImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 2)
        )
    }
}

#Preview {
    AsyncProfileImage(
        imageURL: "https://randomuser.me/api/portraits/thumb/men/75.jpg",
        size: 60
    )
}
