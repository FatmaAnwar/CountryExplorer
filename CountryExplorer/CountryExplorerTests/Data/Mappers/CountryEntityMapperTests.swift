//
//  CountryEntityMapperTests.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import XCTest
import CoreData
@testable import CountryExplorer

final class CountryEntityMapperTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: AppStrings.coreDataModelName)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Load persistent store")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        context = container.viewContext
    }
    
    override func tearDown() {
        context = nil
        super.tearDown()
    }
    
    func test_toEntity_and_fromEntity_roundTrip() {
        // Given
        let country = Country(
            name: "Italy",
            capital: "Rome",
            currencies: [Country.Currency(code: "EUR", name: "Euro", symbol: "€")],
            alpha2Code: "IT",
            latlng: [41.9028, 12.4964]
        )
        let entity = CDCountry(context: context)
        
        // When
        CountryEntityMapper.toEntity(country, into: entity)
        let mapped = CountryEntityMapper.fromEntity(entity)
        
        // Then
        XCTAssertEqual(mapped?.name, "Italy")
        XCTAssertEqual(mapped?.capital, "Rome")
        XCTAssertEqual(mapped?.alpha2Code, "IT")
        XCTAssertEqual(mapped?.latlng?.first, 41.9028)
        XCTAssertEqual(mapped?.currencies?.first?.code, "EUR")
    }
    
    func test_toSelectedEntity_and_fromSelectedEntity_roundTrip() {
        // Given
        let country = Country(
            name: "Egypt",
            capital: "Cairo",
            currencies: [Country.Currency(code: "EGP", name: "Egyptian Pound", symbol: "E£")],
            alpha2Code: "EG",
            latlng: [30.0444, 31.2357]
        )
        let entity = CDSelectedCountry(context: context)
        
        // When
        CountryEntityMapper.toSelectedEntity(country, into: entity)
        let mapped = CountryEntityMapper.fromSelectedEntity(entity)
        
        // Then
        XCTAssertEqual(mapped?.name, "Egypt")
        XCTAssertEqual(mapped?.capital, "Cairo")
        XCTAssertEqual(mapped?.alpha2Code, "EG")
        XCTAssertEqual(mapped?.latlng?.last, 31.2357)
        XCTAssertEqual(mapped?.currencies?.first?.symbol, "E£")
    }
    
    func test_fromEntity_returnsNil_whenMissingRequiredFields() {
        // Given
        let entity = CDCountry(context: context)
        entity.capital = "Oslo" // name and alpha2Code are nil
        
        // When
        let mapped = CountryEntityMapper.fromEntity(entity)
        
        // Then
        XCTAssertNil(mapped)
    }
    
    func test_currencyEncodingDecoding_roundTrip() {
        // Given
        let currencies = [Country.Currency(code: "USD", name: "US Dollar", symbol: "$")]
        
        // When
        let encoded = CountryEntityMapper.encodeCurrencies(from: currencies)
        let decoded = CountryEntityMapper.decodeCurrencies(from: encoded)
        
        // Then
        XCTAssertEqual(decoded?.count, 1)
        XCTAssertEqual(decoded?.first?.name, "US Dollar")
    }
}
