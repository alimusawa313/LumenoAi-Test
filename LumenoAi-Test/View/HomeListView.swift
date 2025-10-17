//
//  HomeListView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI



struct HomeListView: View {
    //    @EnvironmentObject var router: Router
    @Namespace private var animation
    @State private var navigationPath: [NavigationDestination] = []
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var honeycombViewModel = HoneycombViewModel()
    
    @State private var scale: CGFloat = 1.0
    @State private var expandedBubbleId: UUID? = nil
    @State private var viewMode: ViewMode = .grid
    
    enum ViewMode {
        case grid, list
    }
    
    enum NavigationDestination: Hashable {
        case profile
        case userProfile(User)
    }
    
    
    @ViewBuilder
    private var mainContentView: some View {
        Group {
            if userViewModel.isLoading {
                loadingView
            } else if let errorMessage = userViewModel.errorMessage {
                errorView(errorMessage)
            } else if viewMode == .grid {
                gridView
            } else {
                listView
            }
        }
        .transition(.opacity)
        .onChange(of: userViewModel.users) { _, newUsers in
            honeycombViewModel.updateUsers(newUsers)
        }
    }
    
    @ViewBuilder
    private var overlayViews: some View {
        VStack {
            HStack {
                // Empty for now, can add overlay content here
            }
            .padding(.horizontal)
            Spacer()
        }
        
        Spacer()
        HStack { Spacer() }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading users...")
                .font(.headline)
                .foregroundColor(.secondary)
            HStack { Spacer() }
        }
    }
    
    @ViewBuilder
    private func errorView(_ errorMessage: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text("Error")
                .font(.headline)
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Retry") {
                Task {
                    await userViewModel.refreshUsers()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    private var gridView: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ZStack {
                    ForEach(honeycombViewModel.honeycombPositions) { position in
                        DynamicBubble(
                            position: position,
                            viewportSize: geometry.size,
                            expandedBubbleId: $expandedBubbleId,
                            allPositions: honeycombViewModel.honeycombPositions,
                            onViewProfile: { user in
                                navigationPath.append(.userProfile(user))
                            }
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
    }
    
    @ViewBuilder
    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 12) { 
                ForEach(honeycombViewModel.honeycombPositions) { position in
                    ListProfileItemComp(
                        imgSize: 60, 
                        imageName: position.imageName,
                        imageURL: position.imageURL,
                        name: position.name, 
                        email: position.user?.email ?? position.username,
                        user: position.user,
                        onViewProfile: {
                            if let user = position.user {
                                navigationPath.append(.userProfile(user))
                            }
                        }
                    )
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
    
    var body: some View {
        NavigationView{
            NavigationStack(path: $navigationPath) {
                ZStack {
                    mainContentView
                    overlayViews
                }
                .onAppear {
                    if userViewModel.users.isEmpty && !userViewModel.isLoading {
                        Task {
                            await userViewModel.fetchUsers()
                        }
                    } else {
                        
                        honeycombViewModel.updateUsers(userViewModel.users)
                    }
                }
                .toolbar(content: {
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            Task {
                                await userViewModel.refreshUsers()
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .disabled(userViewModel.isLoading)
                        
                        Menu {
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
                            
                            // MARK: - Sort Menu (only when in list mode)
                            //                      if viewMode == .list {
                            //                          Menu {
                            //                              Button {
                            //                                  print("Sort by Name")
                            //                              } label: {
                            //                                  Label("Name", systemImage: "person.text.rectangle")
                            //                              }
                            //                              
                            //                              Button {
                            //                                  print("Sort by Last Active")
                            //                              } label: {
                            //                                  Label("Newest", systemImage: "clock.arrow.circlepath")
                            //                              }
                            //                          } label: {
                            //                              Label("Sort by", systemImage: "arrow.up.arrow.down")
                            //                          }
                            //                      }
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease")
                        }
                    }
                    
                    //              ToolbarItem(placement: .topBarTrailing) {
                    //                  Image(.avatarEx)
                    //                      .resizable()
                    //                      .frame(width: 35, height: 35)
                    //                      .clipShape(Circle())
                    //                      .matchedTransitionSource(id: "profileAvatar", in: animation)
                    //                      .onTapGesture {
                    //                          navigationPath.append(.profile)
                    //                      }
                    //              
                    //            }
                    
                })
                .background(.tertiary.opacity(0.5))
                .navigationTitle("Discover")
                .navigationBarTitleDisplayMode(viewMode == .list ? .large : .inline)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .profile:
                        ProfileView()
                            .navigationTransition(.zoom(sourceID: "profileAvatar", in: animation))
                    case .userProfile(let user):
                        ProfileView(user: user, isCurrentUser: false)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
//    HomeListView()
}

