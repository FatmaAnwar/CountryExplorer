//
//  FetchCountriesUseCase.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation

final class FetchCountriesUseCase: FetchCountriesUseCaseProtocol {
    private let remoteDataSource: CountryRemoteDataSourceProtocol
    
    init(remoteDataSource: CountryRemoteDataSourceProtocol = CountryRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func execute() async throws -> [Country] {
        return try await remoteDataSource.fetchAllCountries()
    }
}
