//
//  MockCountryRemoteDataSource.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import Foundation
@testable import CountryExplorer

final class MockCountryRemoteDataSource: CountryRemoteDataSourceProtocol {
    var stubbedCountries: [Country] = []
    var shouldThrow: Bool = false
    
    func fetchAllCountries() async throws -> [Country] {
        if shouldThrow {
            throw URLError(.notConnectedToInternet)
        }
        return stubbedCountries
    }
}
