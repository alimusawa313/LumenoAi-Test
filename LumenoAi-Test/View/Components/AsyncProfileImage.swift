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
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                Image(fallbackImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
            case .failure:
                Image(fallbackImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
            @unknown default:
                Image(fallbackImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 2)
        )
        .task(id: imageURL) {
            // Preload image in background for better performance
            await preloadImage()
        }
    }
    
    private func preloadImage() async {
        guard let url = URL(string: imageURL) else { return }
        
        await Task.detached(priority: .utility) {
            do {
                // Use optimized URLSession configuration for image preloading
                let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = 5.0
                config.timeoutIntervalForResource = 15.0
                config.waitsForConnectivity = false
                
                let session = URLSession(configuration: config)
                let (_, _) = try await session.data(from: url)
                // Image is now cached by URLSession
            } catch {
                // Silently fail - AsyncImage will handle the error
            }
        }.value
    }
}

#Preview {
    AsyncProfileImage(
        imageURL: "https://randomuser.me/api/portraits/thumb/men/75.jpg",
        size: 60
    )
}
