//
//  CountryLocalDataSource.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import CoreData

final class CountryLocalDataSource: CountryLocalDataSourceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func save(countries: [Country]) {
        clearCountries()
        countries.forEach {
            let entity = CDCountry(context: context)
            CountryEntityMapper.toEntity($0, into: entity)
        }
        CoreDataStack.shared.saveContext()
    }
    
    func getCachedCountries() -> [Country] {
        let request: NSFetchRequest<CDCountry> = CDCountry.fetchRequest()
        return (try? context.fetch(request))?.compactMap {
            CountryEntityMapper.fromEntity($0)
        } ?? []
    }
    
    func clearCountries() {
        let request: NSFetchRequest<NSFetchRequestResult> = CDCountry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? context.execute(deleteRequest)
    }
    
    // MARK: - Selected Countries
    
    func saveSelectedCountries(_ countries: [Country]) {
        clearSelectedCountries()
        countries.forEach {
            let entity = CDSelectedCountry(context: context)
            CountryEntityMapper.toSelectedEntity($0, into: entity)
        }
        CoreDataStack.shared.saveContext()
    }
    
    func getSelectedCountries() -> [Country] {
        let request: NSFetchRequest<CDSelectedCountry> = CDSelectedCountry.fetchRequest()
        return (try? context.fetch(request))?.compactMap {
            CountryEntityMapper.fromSelectedEntity($0)
        } ?? []
    }
    
    func clearSelectedCountries() {
        let request: NSFetchRequest<NSFetchRequestResult> = CDSelectedCountry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? context.execute(deleteRequest)
    }
}
