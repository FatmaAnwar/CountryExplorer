//
//  CountryRemoteDataSourceProtocol.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation

protocol CountryRemoteDataSourceProtocol {
    func fetchAllCountries() async throws -> [Country]
}

final class CountryRemoteDataSource: CountryRemoteDataSourceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchAllCountries() async throws -> [Country] {
        let url = URL(string: "https://restcountries.com/v2/all?fields=name,capital,currencies,alpha2Code,latlng")!
        return try await apiService.fetch(from: url)
    }
}
