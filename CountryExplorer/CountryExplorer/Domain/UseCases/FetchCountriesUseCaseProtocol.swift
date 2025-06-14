//
//  FetchCountriesUseCaseProtocol.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation

protocol FetchCountriesUseCaseProtocol {
    func execute() async throws -> [Country]
}
