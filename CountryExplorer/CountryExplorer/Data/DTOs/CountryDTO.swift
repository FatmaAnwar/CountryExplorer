//
//  CountryDTO.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation

struct CountryDTO: Codable {
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
}
