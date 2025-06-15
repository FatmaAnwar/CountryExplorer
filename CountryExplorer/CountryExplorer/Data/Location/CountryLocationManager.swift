//
//  CountryLocationManager.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import CoreLocation

final class CountryLocationManager: NSObject, CountryLocationManagerProtocol {
    private let locationManager = CLLocationManager()
    private var completion: ((String?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getUserCountryCode(completion: @escaping (String?) -> Void) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension CountryLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            completion?(nil)
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            let countryCode = placemarks?.first?.isoCountryCode
            self.completion?(countryCode)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil)
    }
}
