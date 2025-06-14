//
//  Country.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import CoreLocation

struct Country: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let name: String
    let capital: String?
    let currencies: [Currency]?
    let alpha2Code: String
    let latlng: [Double]?
    
    struct Currency: Codable, Hashable {
        let code: String?
        let name: String?
        let symbol: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case name, capital, currencies, alpha2Code, latlng
    }
}

extension Country {
    var flag: String {
        alpha2Code
            .unicodeScalars
            .compactMap { UnicodeScalar(127397 + $0.value) }
            .map { String($0) }
            .joined()
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latlng?.first, let lng = latlng?.last else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    var currencyDescription: String {
        if let currency = currencies?.first {
            return "\(currency.name ?? "-") (\(currency.code ?? "-"))"
        }
        return "-"
    }
    
    var coordinateDescription: String {
        if let lat = latlng?.first, let lng = latlng?.last {
            return String(format: "%.1f, %.1f", lat, lng)
        }
        return "-"
    }
}
