//
//  CountryRemoteDataSourceProtocol.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation

protocol CountryRemoteDataSourceProtocol {
    func fetchAllCountries() async throws -> [Country]
}
