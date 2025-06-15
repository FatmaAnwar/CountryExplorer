//
//  CountryLocalDataSource.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import CoreData

final class CountryLocalDataSource: CountryLocalDataSourceProtocol {
    private let context = CoreDataStack.shared.context
    
    func save(countries: [Country]) {
        clearCountries()
        
        for country in countries {
            let entity = CDCountry(context: context)
            CountryEntityMapper.toEntity(country, into: entity)
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    func getCachedCountries() -> [Country] {
        let request: NSFetchRequest<CDCountry> = CDCountry.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            return result.compactMap { CountryEntityMapper.fromEntity($0) }
        } catch {
            return []
        }
    }
    
    func clearCountries() {
        let request: NSFetchRequest<NSFetchRequestResult> = CDCountry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? context.execute(deleteRequest)
    }
    
    func saveSelectedCountries(_ countries: [Country]) {
        clearSelectedCountries()
        
        for country in countries {
            let entity = CDSelectedCountry(context: context)
            CountryEntityMapper.toSelectedEntity(country, into: entity)
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    func getSelectedCountries() -> [Country] {
        let request: NSFetchRequest<CDSelectedCountry> = CDSelectedCountry.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            return result.compactMap { CountryEntityMapper.fromSelectedEntity($0) }
        } catch {
            return []
        }
    }
    
    func clearSelectedCountries() {
        let request: NSFetchRequest<NSFetchRequestResult> = CDSelectedCountry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? context.execute(deleteRequest)
    }
}
