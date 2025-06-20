//
//  CoreDataStack.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppStrings.coreDataModelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("\(AppStrings.coreDataLoadError): \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(AppStrings.coreDataSaveError): \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
