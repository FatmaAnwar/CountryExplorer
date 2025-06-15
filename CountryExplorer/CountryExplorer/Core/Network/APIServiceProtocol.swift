//
//  APIServiceProtocol.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}
