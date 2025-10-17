//
//  DynamicBubble.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//


import SwiftUI

struct DynamicBubble: View {
    let position: HoneycombPosition
    let viewportSize: CGSize
    @Binding var expandedBubbleId: UUID?
    let allPositions: [HoneycombPosition]
    var onViewProfile: ((User) -> Void)?
    
    @State private var isExpanded: Bool = false
    @State private var isVisible: Bool = false
    
    // Pre-calculate constants that don't change
    private let distanceFromCanvasCenter: CGFloat
    private let normalizedDirection: CGSize // Unit vector from canvas center
    
    init(position: HoneycombPosition, viewportSize: CGSize, expandedBubbleId: Binding<UUID?>, allPositions: [HoneycombPosition], onViewProfile: ((User) -> Void)? = nil) {
        self.position = position
        self.viewportSize = viewportSize
        self._expandedBubbleId = expandedBubbleId
        self.allPositions = allPositions
        self.onViewProfile = onViewProfile
        
        // Pre-calculate distance from canvas center (only once)
        let dist = sqrt(position.offset.width * position.offset.width +
                        position.offset.height * position.offset.height)
        self.distanceFromCanvasCenter = dist
        
        // Pre-calculate normalized direction (unit vector)
        if dist > 0 {
            self.normalizedDirection = CGSize(
                width: position.offset.width / dist,
                height: position.offset.height / dist
            )
        } else {
            self.normalizedDirection = .zero
        }
    }
    
    var body: some View {
        CircleProfileComp(
            imageName: position.imageName,
            imageURL: position.imageURL,
            name: position.name,
            email: position.username,
            isExpanding: $isExpanded,
            user: position.user,
            onViewProfile: {
                if let user = position.user {
                    onViewProfile?(user)
                }
            }
        )
        .frame(minWidth: 80, minHeight: 80)
        .fixedSize(horizontal: isExpanded ? false : true, vertical: isExpanded ? false : true)
        .zIndex(isExpanded ? 1000 : 0)
        .opacity(isVisible ? 1.0 : 0.0)
        .scaleEffect(isVisible ? 1.0 : 0.1)
        .onAppear {
            // Calculate delay based on ring number for staggered animation
            let delay = Double(position.ring) * 0.15 // 0.15 seconds between rings
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                isVisible = true
            }
        }
        .onChange(of: isExpanded) { oldValue, newValue in
            if newValue {
                expandedBubbleId = position.id
            } else if expandedBubbleId == position.id {
                expandedBubbleId = nil
            }
        }
        .onChange(of: expandedBubbleId) { oldValue, newValue in
            if newValue != position.id && isExpanded {
                isExpanded = false
            }
        }
        .visualEffect { content, proxy in
            let frame = proxy.frame(in: .named("scrollView"))
            
            // Quick viewport center calculation
            let viewportCenterX = viewportSize.width * 0.5
            let viewportCenterY = viewportSize.height * 0.5
            
            // Calculate distance from viewport center using frame midpoints
            let dx = frame.midX - viewportCenterX
            let dy = frame.midY - viewportCenterY
            let distanceSquared = dx * dx + dy * dy
            
            // Use squared distance to avoid sqrt when possible
            // maxDistance = 350, so maxDistanceSquared = 122500
            let normalizedDistance = min(distanceSquared / 122500, 1.0)
            let dynamicScale = 1.5 - (sqrt(normalizedDistance) * 1.0)
            
            // Calculate spacing offset based on scale (using pre-calculated normalized direction)
            let spacingMultiplier = dynamicScale * 0.2
            let spacingOffset = CGSize(
                width: normalizedDirection.width * distanceFromCanvasCenter * spacingMultiplier,
                height: normalizedDirection.height * distanceFromCanvasCenter * spacingMultiplier
            )
            
            // Calculate push-away effect only if a bubble is expanded
            var pushOffset: CGSize = .zero
            // Snapshot the expanded id on the main actor to avoid capturing a main-actor isolated binding
            let currentExpandedId: UUID? = MainActor.assumeIsolated { expandedBubbleId }
            if let expandedId = currentExpandedId,
               expandedId != position.id,
               let expandedPosition = allPositions.first(where: { $0.id == expandedId }) {
                
                let dx = position.offset.width - expandedPosition.offset.width
                let dy = position.offset.height - expandedPosition.offset.height
                let distSquared = dx * dx + dy * dy
                
                // Push away if within range (300^2 = 90000)
                if distSquared < 90000 && distSquared > 0 {
                    let dist = sqrt(distSquared)
                    let pushFactor = (300 - dist) / 300
                    pushOffset = CGSize(
                        width: (dx / dist) * 120 * pushFactor,
                        height: (dy / dist) * 120 * pushFactor
                    )
                }
            }
            
            return content
                .scaleEffect(dynamicScale)
                .offset(x: spacingOffset.width + pushOffset.width,
                        y: spacingOffset.height + pushOffset.height)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: expandedBubbleId)
    }
}
