//
//  CountryDTOMapperTests.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import XCTest
@testable import CountryExplorer

final class CountryDTOMapperTests: XCTestCase {
    
    func test_map_singleDTO() {
        // Given
        let dto = CountryDTO(
            name: "Canada",
            capital: "Ottawa",
            currencies: [CountryDTO.Currency(code: "CAD", name: "Canadian Dollar", symbol: "$")],
            alpha2Code: "CA",
            latlng: [45.4215, -75.6991]
        )
        
        // When
        let result = CountryDTOMapper.map(dto)
        
        // Then
        XCTAssertEqual(result.name, "Canada")
        XCTAssertEqual(result.capital, "Ottawa")
        XCTAssertEqual(result.alpha2Code, "CA")
        XCTAssertEqual(result.latlng?.first, 45.4215)
        XCTAssertEqual(result.currencies?.first?.code, "CAD")
    }
    
    func test_mapList_multipleDTOs() {
        // Given
        let dtos = [
            CountryDTO(name: "US", capital: "DC", currencies: nil, alpha2Code: "US", latlng: nil),
            CountryDTO(name: "UK", capital: "London", currencies: nil, alpha2Code: "GB", latlng: nil)
        ]
        
        // When
        let result = CountryDTOMapper.mapList(dtos)
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "US")
        XCTAssertEqual(result[1].alpha2Code, "GB")
    }
    
    func test_map_withMissingOptionalFields() {
        // Given
        let dto = CountryDTO(
            name: "Norway",
            capital: nil,
            currencies: nil,
            alpha2Code: "NO",
            latlng: nil
        )
        
        // When
        let result = CountryDTOMapper.map(dto)
        
        // Then
        XCTAssertEqual(result.name, "Norway")
        XCTAssertNil(result.capital)
        XCTAssertNil(result.currencies)
        XCTAssertNil(result.latlng)
    }
    
    func test_mapList_empty() {
        // Given
        let dtos: [CountryDTO] = []
        
        // When
        let result = CountryDTOMapper.mapList(dtos)
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_map_currencyFieldsAllNil() {
        // Given
        let dto = CountryDTO(
            name: "Testland",
            capital: "TestCity",
            currencies: [CountryDTO.Currency(code: nil, name: nil, symbol: nil)],
            alpha2Code: "TS",
            latlng: nil
        )
        
        // When
        let result = CountryDTOMapper.map(dto)
        
        // Then
        XCTAssertEqual(result.name, "Testland")
        XCTAssertEqual(result.capital, "TestCity")
        XCTAssertEqual(result.alpha2Code, "TS")
        XCTAssertNil(result.latlng)
        XCTAssertEqual(result.currencies?.count, 1)
        XCTAssertNil(result.currencies?.first?.code)
        XCTAssertNil(result.currencies?.first?.name)
        XCTAssertNil(result.currencies?.first?.symbol)
    }
}
