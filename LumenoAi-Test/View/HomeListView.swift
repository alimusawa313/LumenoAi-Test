//
//  HomeListView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI



struct HomeListView: View {
    //    @EnvironmentObject var router: Router
    
    let honeycombPositions: [HoneycombPosition] = {
        var positions: [HoneycombPosition] = []
        let spacing: CGFloat = 110
        
        let sampleData: [(ImageResource, String, String, Color)] = [
            (.avatarEx, "Alex Chen", "alexchen", .blue.opacity(0.3)),
            (.avatarEx, "Emma Wilson", "emmaw", .pink.opacity(0.3)),
            (.avatarEx, "Sophia Brown", "sophiab", .purple.opacity(0.3)),
            (.avatarEx, "Marcus Knight", "mknight", .orange.opacity(0.3)),
            (.avatarEx, "David Lee", "davidlee", .green.opacity(0.3)),
            (.avatarEx, "Olivia Taylor", "oliviat", .teal.opacity(0.3)),
            (.avatarEx, "Isabella Rose", "isabellar", .mint.opacity(0.3)),
            (.avatarEx, "James Carter", "jcarter", .indigo.opacity(0.3)),
            (.avatarEx, "Ryan Murphy", "ryanm", .cyan.opacity(0.3)),
            (.avatarEx, "Mia Anderson", "miaand", .yellow.opacity(0.3)),
            (.avatarEx, "Ava Martinez", "avam", .red.opacity(0.3)),
            (.avatarEx, "Ethan Davis", "ethand", .brown.opacity(0.3)),
        ]
        
        var dataIndex = 0
        
        // Center item
        let centerData = sampleData[dataIndex % sampleData.count]
        positions.append(HoneycombPosition(
            offset: CGSize(width: 0, height: 0),
            imageName: centerData.0,
            name: centerData.1,
            username: centerData.2,
            backgroundColor: centerData.3
        ))
        dataIndex += 1
        
        // Ring 1 (6 items around center)
        for i in 0..<6 {
            let angle = Double(i) * 60.0 * .pi / 180.0
            let x = cos(angle) * spacing
            let y = sin(angle) * spacing
            let data = sampleData[dataIndex % sampleData.count]
            positions.append(HoneycombPosition(
                offset: CGSize(width: x, height: y),
                imageName: data.0,
                name: data.1,
                username: data.2,
                backgroundColor: data.3
            ))
            dataIndex += 1
        }
        
        // Ring 2 (12 items)
        for i in 0..<12 {
            let angle = Double(i) * 30.0 * .pi / 180.0
            let x = cos(angle) * spacing * 2
            let y = sin(angle) * spacing * 2
            let data = sampleData[dataIndex % sampleData.count]
            positions.append(HoneycombPosition(
                offset: CGSize(width: x, height: y),
                imageName: data.0,
                name: data.1,
                username: data.2,
                backgroundColor: data.3
            ))
            dataIndex += 1
        }
        
        // Ring 3 (18 items)
        for i in 0..<18 {
            let angle = Double(i) * 20.0 * .pi / 180.0
            let x = cos(angle) * spacing * 3
            let y = sin(angle) * spacing * 3
            let data = sampleData[dataIndex % sampleData.count]
            positions.append(HoneycombPosition(
                offset: CGSize(width: x, height: y),
                imageName: data.0,
                name: data.1,
                username: data.2,
                backgroundColor: data.3
            ))
            dataIndex += 1
        }
        
        // Ring 4 (24 items)
        for i in 0..<24 {
            let angle = Double(i) * 15.0 * .pi / 180.0
            let x = cos(angle) * spacing * 4
            let y = sin(angle) * spacing * 4
            let data = sampleData[dataIndex % sampleData.count]
            positions.append(HoneycombPosition(
                offset: CGSize(width: x, height: y),
                imageName: data.0,
                name: data.1,
                username: data.2,
                backgroundColor: data.3
            ))
            dataIndex += 1
        }
        
        return positions
    }()
    
    @State private var scale: CGFloat = 1.0
    @State private var expandedBubbleId: UUID? = nil
    @State private var viewMode: ViewMode = .grid
    
    enum ViewMode {
        case grid, list
    }
    
    var body: some View {
        ZStack{
            
            Group {
                if viewMode == .grid {
                    // Honeycomb Grid View
                    GeometryReader { geometry in
                        ScrollView([.horizontal, .vertical], showsIndicators: false) {
                            ZStack {
                                ForEach(honeycombPositions) { position in
                                    DynamicBubble(
                                        position: position,
                                        viewportSize: geometry.size,
                                        expandedBubbleId: $expandedBubbleId,
                                        allPositions: honeycombPositions
                                    )
                                    .offset(position.offset)
                                }
                            }
                            .frame(width: 1200, height: 1200)
                            .scaleEffect(scale)
                        }
                        .coordinateSpace(name: "scrollView")
                        .scrollIndicators(.hidden)
                        .defaultScrollAnchor(.center)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = min(max(value, 0.5), 2.0)
                                }
                        )
                    }
                } else {
                    // List View
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            Rectangle().frame(height: 50).opacity(0)
                            ForEach(honeycombPositions) { position in
                                
                                ListProfileItemComp(imgSize: 60, imageName: position.imageName, name: position.name, email: position.username)
                                
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .transition(.opacity)
            
            VStack {
                HStack {
                    
                    Menu{
                        Menu {
                            Button {
                                withAnimation(.spring()) {
                                    viewMode = .grid
                                }
                            } label: {
                                Label("Grid", systemImage: viewMode == .grid ? "checkmark" : "square.grid.2x2")
                            }
                            
                            Button {
                                withAnimation(.spring()) {
                                    viewMode = .list
                                }
                            } label: {
                                Label("List", systemImage: viewMode == .list ? "checkmark" : "list.bullet")
                            }
                        } label: {
                            Label("View as", systemImage: "eye")
                        }
                        
                        
                        Menu {
                            Button {
                                print("Sort by Name")
                                // handle sorting by name
                            } label: {
                                Label("Name", systemImage: "person.text.rectangle")
                            }
                            
                            Button {
                                print("Sort by Last Active")
                                // handle sorting by last active
                            } label: {
                                Label("Newest", systemImage: "clock.arrow.circlepath")
                            }
                        } label: {
                            Label("Sort by", systemImage: "arrow.up.arrow.down")
                        }
                        
                        
                    }label: {
                        Image(systemName: "line.horizontal.3.decrease")
                            .foregroundStyle(.blue)
                            .padding()
                            .background(Circle().foregroundStyle(.thinMaterial))
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            
            Spacer()
            HStack{Spacer()}
        }
        .background(.tertiary.opacity(0.5))
        .navigationTitle("Followers")
    }
}

#Preview {
    HomeListView()
}

