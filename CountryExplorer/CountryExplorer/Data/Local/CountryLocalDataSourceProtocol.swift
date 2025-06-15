//
//  CountryLocalDataSourceProtocol.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import CoreData

protocol CountryLocalDataSourceProtocol {
    func save(countries: [Country])
    func getCachedCountries() -> [Country]
    func clearCountries()
    
    func saveSelectedCountries(_ countries: [Country])
    func getSelectedCountries() -> [Country]
    func clearSelectedCountries()
}
