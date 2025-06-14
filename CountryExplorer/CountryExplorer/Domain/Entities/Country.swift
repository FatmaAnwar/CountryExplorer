//
//  Country.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation

struct Country: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let name: String
    let capital: String?
    let currencies: [Currency]?
    let alpha2Code: String
    let latlng: [Double]?
    
    struct Currency: Codable, Equatable, Hashable {
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
            .uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(127397 + $0.value) }
            .map { String($0) }
            .joined()
    }
}
