//
//  CoreDataStackTests.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import XCTest
import CoreData
@testable import CountryExplorer

final class CoreDataStackTests: XCTestCase {
    
    var container: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        container = NSPersistentContainer(name: AppStrings.coreDataModelName)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Load persistent stores")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    override func tearDown() {
        container = nil
        super.tearDown()
    }
    
    func test_persistentContainerLoadsSuccessfully() {
        // Given & When
        let context = container.viewContext
        
        // Then
        XCTAssertNotNil(context)
    }
    
    func test_saveContext_whenHasChanges_shouldSave() {
        // Given
        let context = container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CDCountry", in: context)!
        let country = NSManagedObject(entity: entity, insertInto: context)
        
        country.setValue("Testland", forKey: "name")
        country.setValue("TL", forKey: "alpha2Code")
        country.setValue("🇹🇱", forKey: "flag")
        country.setValue(0.0, forKey: "lat")
        country.setValue(0.0, forKey: "lng")
        country.setValue(nil, forKey: "capital")
        country.setValue(nil, forKey: "currencies")

        // When & Then
        XCTAssertTrue(context.hasChanges)
        do {
            try context.save()
        } catch {
            XCTFail("Expected to save without error, got: \(error)")
        }
    }
    
    func test_saveContext_whenNoChanges_shouldNotThrow() {
        // Given
        let context = container.viewContext
        XCTAssertFalse(context.hasChanges)
        
        // When & Then
        XCTAssertNoThrow(try context.save())
    }
}
