//
//  MockFetchCountriesUseCase.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
@testable import CountryExplorer

final class MockFetchCountriesUseCase: FetchCountriesUseCaseProtocol {
    var stubbedResult: Result<[Country], Error> = .success([])
    
    func execute() async throws -> [Country] {
        switch stubbedResult {
        case .success(let countries):
            return countries
        case .failure(let error):
            throw error
        }
    }
}
