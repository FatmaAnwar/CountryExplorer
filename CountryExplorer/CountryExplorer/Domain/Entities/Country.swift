//
//  Country.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation

struct Country: Identifiable, Codable {
    let id = UUID()
    
    let name: String
    let capital: String?
    let currencies: [Currency]?
    let alpha2Code: String
    let latlng: [Double]?
    
    struct Currency: Codable {
        let code: String?
        let name: String?
        let symbol: String?
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, capital, currencies, alpha2Code, latlng
    }
}

