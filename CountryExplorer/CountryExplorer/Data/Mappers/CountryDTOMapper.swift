//
//  CountryDTOMapper.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation

struct CountryDTOMapper {
    static func map(_ dto: CountryDTO) -> Country {
        return Country(
            name: dto.name,
            capital: dto.capital,
            currencies: dto.currencies?.map {
                Country.Currency(code: $0.code, name: $0.name, symbol: $0.symbol)
            },
            alpha2Code: dto.alpha2Code,
            latlng: dto.latlng
        )
    }
    
    static func mapList(_ dtos: [CountryDTO]) -> [Country] {
        return dtos.map { map($0) }
    }
}
