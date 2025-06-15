//
//  MockCountryLocalDataSource.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
@testable import CountryExplorer

final class MockCountryLocalDataSource: CountryLocalDataSourceProtocol {
    var stubbedCachedCountries: [Country] = []
    var stubbedSelectedCountries: [Country] = []
    
    private(set) var savedCountries: [Country] = []
    private(set) var savedSelectedCountries: [Country] = []
    
    func save(countries: [Country]) {
        savedCountries = countries
    }
    
    func getCachedCountries() -> [Country] {
        return stubbedCachedCountries
    }
    
    func clearCountries() {
        savedCountries = []
    }
    
    func saveSelectedCountries(_ countries: [Country]) {
        savedSelectedCountries = countries
    }
    
    func getSelectedCountries() -> [Country] {
        return stubbedSelectedCountries
    }
    
    func clearSelectedCountries() {
        savedSelectedCountries = []
    }
}
