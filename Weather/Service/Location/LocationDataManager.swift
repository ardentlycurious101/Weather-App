//
//  ViewController+CoreLocation.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/21/23.
//

import Foundation
import CoreLocation

class LocationDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager = CLLocationManager()
    
    // Callback closure to handle location updates
    var locationUpdated: ((_ userCoordinates: (lat: Double, lon: Double)?) -> Void)?
    
    init(locationUpdated: @escaping (_ userCoordinates: (lat: Double, lon: Double)?) -> Void) {
        super.init()
        self.locationManager.delegate = self
        self.locationUpdated = locationUpdated
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            enableLocationFeatures()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            disableLocationFeatures()
            break
            
        case .notDetermined:        // Authorization not determined yet.
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func enableLocationFeatures() {
        locationManager.requestLocation()
    }
    
    func disableLocationFeatures() {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("Found user's location: \(location.description)")

        let coordinates = (Double(location.coordinate.latitude), Double(location.coordinate.longitude))
        
        self.locationUpdated?(coordinates)
        
        manager.stopUpdatingLocation() // Stop updating location when you no longer need it.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // handle error
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
}
