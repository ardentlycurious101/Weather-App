//
//  SearchResult.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//


import Foundation

// MARK: - SearchResultElement
struct SearchResultElement: Codable {
    let name: String?
    let lat, lon: Double?
    let country, state: String?
    
    var fullName: String {
        var nameComponents: [String] = []
        
        if let cityName = self.name {
            nameComponents.append(cityName)
        }
        
        if let state = self.state {
            nameComponents.append(state)
        }
        
        if let country = self.country {
            nameComponents.append(country)
        }
        
        return nameComponents.joined(separator: ", ")
    }
    
    var coordinates: (lat: Double, lon: Double)? {
        if let lat = self.lat, let lon = self.lon {
            return (lat, lon)
        }
        
        return nil
    }
}
