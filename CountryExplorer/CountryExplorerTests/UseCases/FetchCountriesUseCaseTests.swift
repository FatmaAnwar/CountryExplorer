//
//  FetchCountriesUseCaseTests.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import XCTest
@testable import CountryExplorer

final class FetchCountriesUseCaseTests: XCTestCase {
    
    private var mockRemoteDataSource: MockCountryRemoteDataSource!
    private var useCase: FetchCountriesUseCase!
    
    override func setUp() {
        super.setUp()
        mockRemoteDataSource = MockCountryRemoteDataSource()
        useCase = FetchCountriesUseCase(remoteDataSource: mockRemoteDataSource)
    }
    
    override func tearDown() {
        mockRemoteDataSource = nil
        useCase = nil
        super.tearDown()
    }
    
    func test_execute_success_returnsCountries() async throws {
        // Given
        let expectedCountries = [
            Country(name: "Germany", capital: "Berlin", currencies: nil, alpha2Code: "DE", latlng: [52.52, 13.405])
        ]
        mockRemoteDataSource.stubbedCountries = expectedCountries
        
        // When
        let result = try await useCase.execute()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Germany")
    }
    
    func test_execute_empty_returnsEmptyList() async throws {
        // Given
        mockRemoteDataSource.stubbedCountries = []
        
        // When
        let result = try await useCase.execute()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_execute_failure_throwsError() async {
        // Given
        mockRemoteDataSource.shouldThrow = true
        
        // When & Then
        do {
            _ = try await useCase.execute()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
