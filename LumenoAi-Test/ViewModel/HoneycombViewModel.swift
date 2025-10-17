//
//  HoneycombViewModel.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class HoneycombViewModel: ObservableObject {
    @Published var users: [User] = []
    
    init(users: [User] = []) {
        self.users = users
    }
    
    func updateUsers(_ newUsers: [User]) {
        self.users = newUsers
    }
    
    var honeycombPositions: [HoneycombPosition] {
        guard !users.isEmpty else { return [] }
        
        var positions: [HoneycombPosition] = []
        let spacing: CGFloat = 110
        var userIndex = 0
        
        // Center item
        if userIndex < users.count {
            let user = users[userIndex]
            positions.append(HoneycombPosition(
                offset: CGSize(width: 0, height: 0),
                imageName: .avatarEx,
                imageURL: user.picture.thumbnail,
                name: user.name.fullName,
                username: user.login.username,
                backgroundColor: user.honeycombPosition.backgroundColor,
                user: user
            ))
            userIndex += 1
        }
        
        // Ring 1 (6 items around center)
        for i in 0..<6 {
            let angle = Double(i) * 60.0 * .pi / 180.0
            let x = cos(angle) * spacing
            let y = sin(angle) * spacing
            if userIndex < users.count {
                let user = users[userIndex]
                positions.append(HoneycombPosition(
                    offset: CGSize(width: x, height: y),
                    imageName: .avatarEx,
                    imageURL: user.picture.thumbnail,
                    name: user.name.fullName,
                    username: user.login.username,
                    backgroundColor: user.honeycombPosition.backgroundColor,
                    user: user
                ))
                userIndex += 1
            }
        }
        
        // Ring 2 (12 items)
        for i in 0..<12 {
            let angle = Double(i) * 30.0 * .pi / 180.0
            let x = cos(angle) * spacing * 2
            let y = sin(angle) * spacing * 2
            if userIndex < users.count {
                let user = users[userIndex]
                positions.append(HoneycombPosition(
                    offset: CGSize(width: x, height: y),
                    imageName: .avatarEx,
                    imageURL: user.picture.thumbnail,
                    name: user.name.fullName,
                    username: user.login.username,
                    backgroundColor: user.honeycombPosition.backgroundColor,
                    user: user
                ))
                userIndex += 1
            }
        }
        
        // Ring 3 (18 items)
        for i in 0..<18 {
            let angle = Double(i) * 20.0 * .pi / 180.0
            let x = cos(angle) * spacing * 3
            let y = sin(angle) * spacing * 3
            if userIndex < users.count {
                let user = users[userIndex]
                positions.append(HoneycombPosition(
                    offset: CGSize(width: x, height: y),
                    imageName: .avatarEx,
                    imageURL: user.picture.thumbnail,
                    name: user.name.fullName,
                    username: user.login.username,
                    backgroundColor: user.honeycombPosition.backgroundColor,
                    user: user
                ))
                userIndex += 1
            }
        }
        
        // Ring 4 (24 items)
        for i in 0..<24 {
            let angle = Double(i) * 15.0 * .pi / 180.0
            let x = cos(angle) * spacing * 4
            let y = sin(angle) * spacing * 4
            if userIndex < users.count {
                let user = users[userIndex]
                positions.append(HoneycombPosition(
                    offset: CGSize(width: x, height: y),
                    imageName: .avatarEx,
                    imageURL: user.picture.thumbnail,
                    name: user.name.fullName,
                    username: user.login.username,
                    backgroundColor: user.honeycombPosition.backgroundColor,
                    user: user
                ))
                userIndex += 1
            }
        }
        
        return positions
    }
}
