//
//  ProfileView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI
import MapKit

struct ProfileView: View {
    @State private var selectedTab = "info"
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolled: Bool = false
    
    var isCurrentUser: Bool = false // Set to true for current user's profile
    
    private let scrollThreshold: CGFloat = 80
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Image(.avatarEx)
                        .resizable()
                        .scaledToFill()
                        .frame(height: isScrolled ? 0 : max(300 - scrollOffset, 0))
                        .opacity(isScrolled ? 0 : 1)
                        .ignoresSafeArea()
                        .animation(.easeInOut(duration: 0.3), value: isScrolled)
                        .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: isScrolled ? 0 : 150)
                            .opacity(isScrolled ? 0 : 1)
                            .foregroundStyle(LinearGradient(colors: [.clear, Color(.systemBackground), Color(.systemBackground)], startPoint: .top, endPoint: .bottom))
                            .allowsHitTesting(false)
                            .animation(.easeInOut(duration: 0.8), value: isScrolled)
                            .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                            .padding(.bottom, -10)
                    }
                }
                .frame(height: isScrolled ? 0 : max(300 - scrollOffset, 0))
                .animation(.easeInOut(duration: 0.3), value: isScrolled)
                .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                
                Spacer()
            }
            
            ScrollView {
                VStack{
                    Rectangle()
                        .frame(height: 200)
                        .opacity(0)
                    HStack{
                        Text("Jennie Nichols")
                            .font(.title3)
                            .bold()
                            .padding(.bottom, 10)
                        
                        Spacer()
                        
                        Button(action: {
                            // Action for follow/edit
                        }) {
                            Text(isCurrentUser ? "Edit Profile" : "Follow")
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(isCurrentUser ? Color.gray : Color.blue)
                                .clipShape(Capsule())
                        }
                        .opacity(isScrolled ? 0 : 1)
                        .animation(.easeInOut(duration: 0.3), value: isScrolled)
                        .padding(.bottom, 10)
                    }
            
            HStack{
                VStack{
                    Text("Followers")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                    Text("123")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.thinMaterial))
                VStack{
                    Text("Followers")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                    Text("123")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.thinMaterial))
                
            }
            .padding(.vertical)
            
            Picker("Select Tab", selection: $selectedTab) {
                Text("Info").tag("info")
                Text("Location").tag("location")
            }
            .pickerStyle(.segmented)
            
            if selectedTab == "info" {
                VStack{
                    VStack(alignment: .leading){
                        Text("name")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("Miss Jennie Nichols")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("username")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("yellowpeacock117")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("email")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("email@email.com")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("gender")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("Male")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("phone")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("+1 (555) 123-4567")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("cell")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("+1 (555) 987-6543")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                }
                .padding(.top)
            } else {
                VStack {
                    Map {
                        Marker("Location", coordinate: CLLocationCoordinate2D(latitude: -69.8246, longitude: 134.8719))
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom)
                    
                    VStack(alignment: .leading){
                        Text("street")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("8929 Valwood Pkwy")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("city")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("Billings")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("state")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("Michigan")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("country")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("United States")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("postcode")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("63104")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("coordinates")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("Latitude: -69.8246, Longitude: 134.8719")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                    
                    VStack(alignment: .leading){
                        Text("timezone")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        
                        Text("+9:30 (Adelaide, Darwin)")
                            .bold()
                        HStack{Spacer()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
                }
                .padding(.top)
            }
            
            Spacer()
                }
                .padding(.horizontal)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                scrollOffset = 0
                            }
                            .onChange(of: geometry.frame(in: .global).minY) { newValue in
                                let offset = max(0, -newValue)
                                scrollOffset = offset
                                isScrolled = offset > scrollThreshold
                            }
                    }
                )
            }
            
            // Compact header when scrolled
            VStack {
                HStack {
                    Image(.avatarEx)
                        .resizable()
                        .scaledToFill()
                        .frame(width: isScrolled ? 35 : 0, height: isScrolled ? 35 : 0)
                        .clipShape(Circle())
                        .opacity(isScrolled ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isScrolled)
                    
                    Text("Jennie Nichols")
                        .font(.headline)
                        .bold()
                        .opacity(isScrolled ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isScrolled)
                    
                    Spacer()
                    
                    Button(action: {
                        // Action for follow/edit
                    }) {
                        Text(isCurrentUser ? "Edit" : "Follow")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(isCurrentUser ? Color.gray : Color.blue)
                            .clipShape(Capsule())
                    }
                    .opacity(isScrolled ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: isScrolled)
                }
                .padding()
                .background(Color(.systemBackground).opacity(isScrolled ? 1 : 0))
                .animation(.easeInOut(duration: 0.3), value: isScrolled)
                
                Spacer()
            }
        }
    }
}

#Preview("Not Current User") {
    ProfileView(isCurrentUser: false)
}

#Preview("Current User") {
    ProfileView(isCurrentUser: true)
}
