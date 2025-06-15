//
//  CountryLocalDataSourceTests.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import XCTest
import CoreData
@testable import CountryExplorer

final class CountryLocalDataSourceTests: XCTestCase {
    
    var sut: CountryLocalDataSource!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        let container = NSPersistentContainer(name: AppStrings.coreDataModelName)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Load persistent stores")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        context = container.viewContext
        sut = CountryLocalDataSource(context: context)
    }
    
    override func tearDown() {
        sut = nil
        context = nil
        super.tearDown()
    }
    
    func test_saveAndGetCachedCountries_success() {
        // Given
        let country = Country(name: "Germany", capital: "Berlin", currencies: nil, alpha2Code: "DE", latlng: [52.52, 13.405])
        sut.save(countries: [country])
        
        // When
        let result = sut.getCachedCountries()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Germany")
    }
    
    func test_clearCountries_success() {
        // Given
        let country = Country(name: "France", capital: "Paris", currencies: nil, alpha2Code: "FR", latlng: nil)
        sut.save(countries: [country])
        
        // When
        sut.clearCountries()
        let result = sut.getCachedCountries()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_saveAndGetSelectedCountries_success() {
        // Given
        let country = Country(name: "Japan", capital: "Tokyo", currencies: nil, alpha2Code: "JP", latlng: [35.6762, 139.6503])
        sut.saveSelectedCountries([country])
        
        // When
        let result = sut.getSelectedCountries()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.alpha2Code, "JP")
    }
    
    func test_clearSelectedCountries_success() {
        // Given
        let country = Country(name: "Brazil", capital: "Brasília", currencies: nil, alpha2Code: "BR", latlng: nil)
        sut.saveSelectedCountries([country])
        
        // When
        sut.clearSelectedCountries()
        let result = sut.getSelectedCountries()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_getCachedCountries_returnsEmptyWhenNothingSaved() {
        // When
        let result = sut.getCachedCountries()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_getSelectedCountries_returnsEmptyWhenNothingSaved() {
        // When
        let result = sut.getSelectedCountries()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
}
