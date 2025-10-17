//
//  UserResponse.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import Foundation

// MARK: - Main Response
struct UserResponse: Codable {
    let results: [User]
    let info: Info
}

// MARK: - User
struct User: Codable, Equatable, Hashable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: DateInfo
    let registered: DateInfo
    let phone: String
    let cell: String
    let id: ID
    let picture: Picture
    let nat: String
}

// MARK: - Name
struct Name: Codable, Equatable, Hashable {
    let title: String
    let first: String
    let last: String
    
    var fullName: String {
        "\(first) \(last)"
    }
    
    var fullNameWithTitle: String {
        "\(title) \(first) \(last)"
    }
}

// MARK: - Location
struct Location: Codable, Equatable, Hashable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: String
    let coordinates: Coordinates
    let timezone: Timezone
    
    var fullAddress: String {
        "\(street.number) \(street.name), \(city), \(state) \(postcode), \(country)"
    }
    
    enum CodingKeys: String, CodingKey {
        case street, city, state, country, postcode, coordinates, timezone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try container.decode(Street.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        timezone = try container.decode(Timezone.self, forKey: .timezone)
        
        // Handle postcode as either String or Int
        if let postcodeString = try? container.decode(String.self, forKey: .postcode) {
            postcode = postcodeString
        } else if let postcodeInt = try? container.decode(Int.self, forKey: .postcode) {
            postcode = String(postcodeInt)
        } else {
            postcode = ""
        }
    }
}

// MARK: - Street
struct Street: Codable, Equatable, Hashable {
    let number: Int
    let name: String
}

// MARK: - Coordinates
struct Coordinates: Codable, Equatable, Hashable {
    let latitude: String
    let longitude: String
    
    var latitudeDouble: Double? {
        Double(latitude)
    }
    
    var longitudeDouble: Double? {
        Double(longitude)
    }
}

// MARK: - Timezone
struct Timezone: Codable, Equatable, Hashable {
    let offset: String
    let description: String
}

// MARK: - Login
struct Login: Codable, Equatable, Hashable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

// MARK: - DateInfo
struct DateInfo: Codable, Equatable, Hashable {
    let date: String
    let age: Int
    
    var dateObject: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: date)
    }
    
    var formattedDate: String? {
        guard let date = dateObject else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - ID
struct ID: Codable, Equatable, Hashable {
    let name: String
    let value: String?
}

// MARK: - Picture
struct Picture: Codable, Equatable, Hashable {
    let large: String
    let medium: String
    let thumbnail: String
}

// MARK: - Info
struct Info: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

