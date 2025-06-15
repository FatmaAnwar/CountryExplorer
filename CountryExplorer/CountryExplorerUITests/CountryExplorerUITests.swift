//
//  CountryExplorerUITests.swift
//  CountryExplorerUITests
//
//  Created by Fatma Anwar on 14/06/2025.
//

import XCTest

final class CountryExplorerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func test_home_showsBrowseButton() {
        let browseButton = app.buttons["Browse Countries"]
        XCTAssertTrue(browseButton.waitForExistence(timeout: 3))
    }

    func test_browseScreen_displaysUIElements_andCountries() {
        app.buttons["Browse Countries"].tap()
        
        let navTitle = app.navigationBars["Browse Countries"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 3))

        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 2))

        let searchField = app.textFields["Search countries"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))

        let firstCountryCell = app.scrollViews.descendants(matching: .button).firstMatch
        XCTAssertTrue(firstCountryCell.waitForExistence(timeout: 2))
    }

    func test_tapDone_returnsToHome() {
        app.buttons["Browse Countries"].tap()
        app.buttons["Done"].tap()
        
        let homeBrowseButton = app.buttons["Browse Countries"]
        XCTAssertTrue(homeBrowseButton.waitForExistence(timeout: 3))
    }
}
