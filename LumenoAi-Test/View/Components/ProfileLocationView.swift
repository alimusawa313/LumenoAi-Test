//
//  ProfileLocationView.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI
import MapKit

struct ProfileLocationView: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: 16) {
            MapView(user: user)
            
            LocationInfoField(label: "street", value: user?.location.street.name ?? "N/A")
            LocationInfoField(label: "city", value: user?.location.city ?? "N/A")
            LocationInfoField(label: "state", value: user?.location.state ?? "N/A")
            LocationInfoField(label: "country", value: user?.location.country ?? "N/A")
            LocationInfoField(label: "postcode", value: user?.location.postcode ?? "N/A")
            LocationInfoField(
                label: "coordinates",
                value: "Latitude: \(user?.location.coordinates.latitude ?? "N/A"), Longitude: \(user?.location.coordinates.longitude ?? "N/A")"
            )
            LocationInfoField(
                label: "timezone",
                value: "\(user?.location.timezone.offset ?? "N/A") (\(user?.location.timezone.description ?? "N/A"))"
            )
        }
        .padding(.top)
    }
}

struct MapView: View {
    let user: User?
    
    var body: some View {
        if let latitude = user?.location.coordinates.latitudeDouble,
           let longitude = user?.location.coordinates.longitudeDouble {
            Map(initialPosition: .camera(MapCamera(
                centerCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                distance: 10000000, // 10,000 km - very far zoom out
                heading: 0,
                pitch: 0
            ))) {
                Marker("Location", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        } else {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 250)
                .overlay(
                    VStack {
                        Image(systemName: "location.circle")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("Location not available")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                )
        }
    }
}

struct LocationInfoField: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .foregroundStyle(.secondary)
                .font(.caption)
            
            Text(value)
                .bold()
            HStack { Spacer() }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.thinMaterial))
    }
}

#Preview {
    ProfileLocationView(user: nil)
}
