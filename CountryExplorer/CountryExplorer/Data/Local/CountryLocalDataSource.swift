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
            entity.name = country.name
            entity.capital = country.capital
            entity.alpha2Code = country.alpha2Code
            entity.lat = country.latlng?.first ?? 0
            entity.lng = country.latlng?.last ?? 0
            entity.flag = country.flag
            entity.currencies = try? JSONEncoder().encode(country.currencies).base64EncodedString()
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    func getCachedCountries() -> [Country] {
        let request: NSFetchRequest<CDCountry> = CDCountry.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            return result.compactMap { cd in
                guard
                    let name = cd.name,
                    let alpha2Code = cd.alpha2Code
                else { return nil }
                
                return Country(
                    name: name,
                    capital: cd.capital,
                    currencies: decodeCurrencies(from: cd.currencies),
                    alpha2Code: alpha2Code,
                    latlng: [cd.lat, cd.lng]
                )
            }
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
            entity.name = country.name
            entity.capital = country.capital
            entity.alpha2Code = country.alpha2Code
            entity.lat = country.latlng?.first ?? 0
            entity.lng = country.latlng?.last ?? 0
            entity.flag = country.flag
            entity.currencies = try? JSONEncoder().encode(country.currencies).base64EncodedString()
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    func getSelectedCountries() -> [Country] {
        let request: NSFetchRequest<CDSelectedCountry> = CDSelectedCountry.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            return result.compactMap { cd in
                guard
                    let name = cd.name,
                    let alpha2Code = cd.alpha2Code
                else { return nil }
                
                return Country(
                    name: name,
                    capital: cd.capital,
                    currencies: decodeCurrencies(from: cd.currencies),
                    alpha2Code: alpha2Code,
                    latlng: [cd.lat, cd.lng]
                )
            }
        } catch {
            return []
        }
    }
    
    func clearSelectedCountries() {
        let request: NSFetchRequest<NSFetchRequestResult> = CDSelectedCountry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? context.execute(deleteRequest)
    }
    
    private func decodeCurrencies(from base64: String?) -> [Country.Currency]? {
        guard
            let base64 = base64,
            let data = Data(base64Encoded: base64)
        else { return nil }
        
        return try? JSONDecoder().decode([Country.Currency].self, from: data)
    }
}
