//
//  CountryListViewModelTests.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import XCTest
import Combine
@testable import CountryExplorer

@MainActor
final class CountryListViewModelTests: XCTestCase {
    
    private var sut: CountryListViewModel!
    private var mockUseCase: MockFetchCountriesUseCase!
    private var mockLocalDataSource: MockCountryLocalDataSource!
    private var mockNetworkMonitor: MockNetworkMonitor!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCountriesUseCase()
        mockLocalDataSource = MockCountryLocalDataSource()
        mockNetworkMonitor = MockNetworkMonitor(isConnected: true)
        sut = CountryListViewModel(
            fetchCountriesUseCase: mockUseCase,
            localDataSource: mockLocalDataSource,
            networkMonitor: mockNetworkMonitor
        )
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockLocalDataSource = nil
        mockNetworkMonitor = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_initialState_isCorrect() {
        XCTAssertTrue(sut.countries.isEmpty)
        XCTAssertTrue(sut.selectedCountries.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_fetchCountries_whenOnline_success() async {
        // Given
        let expected = [
            Country(name: "Canada", capital: "Ottawa", currencies: nil, alpha2Code: "CA", latlng: nil)
        ]
        mockUseCase.stubbedResult = .success(expected)
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertEqual(sut.countries.count, 1)
        XCTAssertEqual(sut.countries.first?.name, "Canada")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_fetchCountries_whenOffline_shouldLoadFromCache() async {
        // Given
        mockNetworkMonitor.isConnected = false
        let cached = [
            Country(name: "Egypt", capital: "Cairo", currencies: nil, alpha2Code: "EG", latlng: nil)
        ]
        mockLocalDataSource.stubbedCachedCountries = cached
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertEqual(sut.countries.count, 1)
        XCTAssertEqual(sut.countries.first?.name, "Egypt")
    }
    
    func test_toggleSelection_selectsAndDeselects() {
        // Given
        let country = Country(name: "France", capital: "Paris", currencies: nil, alpha2Code: "FR", latlng: nil)
        
        // When
        sut.toggleSelection(country)
        XCTAssertTrue(sut.selectedCountries.contains(where: { $0.alpha2Code == "FR" }))
        
        // When toggle again
        sut.toggleSelection(country)
        XCTAssertFalse(sut.selectedCountries.contains(where: { $0.alpha2Code == "FR" }))
    }
    
    func test_selectionLimit_shouldNotExceedFive() {
        // Given
        let countries = (1...6).map {
            Country(name: "Country\($0)", capital: nil, currencies: nil, alpha2Code: "C\($0)", latlng: nil)
        }
        
        // When
        countries.forEach { sut.toggleSelection($0) }
        
        // Then
        XCTAssertEqual(sut.selectedCountries.count, 5)
    }
    
    func test_searchTextFiltersCountries() {
        // Given
        sut._injectCountriesForTesting([
            Country(name: "Canada", capital: nil, currencies: nil, alpha2Code: "CA", latlng: nil),
            Country(name: "Cameroon", capital: nil, currencies: nil, alpha2Code: "CM", latlng: nil),
            Country(name: "France", capital: nil, currencies: nil, alpha2Code: "FR", latlng: nil)
        ])
        
        let expectation = XCTestExpectation(description: "Debounced search")
        sut.$debouncedSearchText
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value, "Cam")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.searchText = "Cam"
        
        // Then
        wait(for: [expectation], timeout: 1.5)
    }
    
    func test_fetchCountries_whenOnlineFails_shouldLoadCacheAndShowErrorMessage() async {
        // Given
        mockNetworkMonitor.isConnected = true
        mockUseCase.stubbedResult = .failure(URLError(.badServerResponse))
        mockLocalDataSource.stubbedCachedCountries = [
            Country(name: "OfflineLand", capital: nil, currencies: nil, alpha2Code: "OL", latlng: nil)
        ]
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertEqual(sut.countries.count, 1)
        XCTAssertEqual(sut.countries.first?.name, "OfflineLand")
        XCTAssertEqual(sut.errorMessage, AppStrings.networkFallbackMessage)
    }
    
    func test_loadSelectedCountries_shouldRestoreSelectionFromLocalDataSource() {
        // Given
        let saved = [
            Country(name: "Italy", capital: "Rome", currencies: nil, alpha2Code: "IT", latlng: nil)
        ]
        mockLocalDataSource.stubbedSelectedCountries = saved
        
        // When
        sut.loadSelectedCountries()
        
        // Then
        XCTAssertEqual(sut.selectedCountries.count, 1)
        XCTAssertEqual(sut.selectedCountries.first?.alpha2Code, "IT")
    }
}
