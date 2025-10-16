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
    let name: String
    let username: String
    let backgroundColor: Color
}
