//
//  LocationManager.swift
//  FindCoffee
//
//  Created by Anton on 07.02.24.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    var userLocation: CLLocation?
    var locationUpdateCompletion: ((CLLocation?) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestUserLocation(completion: @escaping (CLLocation?) -> Void) {
        locationManager.requestWhenInUseAuthorization()
        locationUpdateCompletion = completion
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        locationUpdateCompletion?(location)
        locationUpdateCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error)")
        locationUpdateCompletion?(nil)
        locationUpdateCompletion = nil
    }
    
    func distanceFromUserToCoffeeShop(coffeeLatitude: Double, coffeeLongitude: Double) -> Double? {
        guard let userLocation = userLocation else { return nil }
        
        let coffeeLocation = CLLocation(latitude: coffeeLatitude, longitude: coffeeLongitude)
        return userLocation.distance(from: coffeeLocation) / 1000 
    }
}


