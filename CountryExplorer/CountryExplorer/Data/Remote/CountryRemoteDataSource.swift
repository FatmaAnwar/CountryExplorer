//
//  CountryRemoteDataSource.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation

final class CountryRemoteDataSource: CountryRemoteDataSourceProtocol {
    private let apiService: APIServiceProtocol
    private let endpoint = URL(string: AppStrings.apiAllCountriesEndpoint)!
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchAllCountries() async throws -> [Country] {
        let dtos: [CountryDTO] = try await apiService.fetch(from: endpoint)
        return CountryDTOMapper.mapList(dtos)
    }
}
