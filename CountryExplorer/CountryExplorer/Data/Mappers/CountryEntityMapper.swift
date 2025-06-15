//
//  CountryEntityMapper.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation

struct CountryEntityMapper {
    
    static func fromEntity(_ entity: CDCountry) -> Country? {
        guard let name = entity.name,
              let alpha2Code = entity.alpha2Code else {
            return nil
        }
        
        return Country(
            name: name,
            capital: entity.capital,
            currencies: decodeCurrencies(from: entity.currencies),
            alpha2Code: alpha2Code,
            latlng: [entity.lat, entity.lng]
        )
    }
    
    static func fromSelectedEntity(_ entity: CDSelectedCountry) -> Country? {
        guard let name = entity.name,
              let alpha2Code = entity.alpha2Code else {
            return nil
        }
        
        return Country(
            name: name,
            capital: entity.capital,
            currencies: decodeCurrencies(from: entity.currencies),
            alpha2Code: alpha2Code,
            latlng: [entity.lat, entity.lng]
        )
    }
    
    static func toEntity(_ country: Country, into entity: CDCountry) {
        entity.name = country.name
        entity.capital = country.capital
        entity.alpha2Code = country.alpha2Code
        entity.lat = country.latlng?.first ?? 0
        entity.lng = country.latlng?.last ?? 0
        entity.flag = country.flag
        entity.currencies = encodeCurrencies(from: country.currencies)
    }
    
    static func toSelectedEntity(_ country: Country, into entity: CDSelectedCountry) {
        entity.name = country.name
        entity.capital = country.capital
        entity.alpha2Code = country.alpha2Code
        entity.lat = country.latlng?.first ?? 0
        entity.lng = country.latlng?.last ?? 0
        entity.flag = country.flag
        entity.currencies = encodeCurrencies(from: country.currencies)
    }
    
    private static func encodeCurrencies(from currencies: [Country.Currency]?) -> String? {
        guard let currencies = currencies,
              let data = try? JSONEncoder().encode(currencies) else { return nil }
        return data.base64EncodedString()
    }
    
    private static func decodeCurrencies(from base64: String?) -> [Country.Currency]? {
        guard let base64 = base64,
              let data = Data(base64Encoded: base64) else { return nil }
        return try? JSONDecoder().decode([Country.Currency].self, from: data)
    }
}
