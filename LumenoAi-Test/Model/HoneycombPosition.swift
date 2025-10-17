//
//  HoneycombPosition.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct HoneycombPosition: Identifiable {
    let id = UUID()
    let offset: CGSize
    let imageName: ImageResource
    let imageURL: String?
    let name: String
    let username: String
    let backgroundColor: Color
    let user: User?
    
    init(offset: CGSize, imageName: ImageResource, imageURL: String? = nil, name: String, username: String, backgroundColor: Color, user: User? = nil) {
        self.offset = offset
        self.imageName = imageName
        self.imageURL = imageURL
        self.name = name
        self.username = username
        self.backgroundColor = backgroundColor
        self.user = user
    }
}
