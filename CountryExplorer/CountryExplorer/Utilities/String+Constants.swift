//
//  String+Constants.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation

enum AppStrings {
    
    // MARK: - Browse Countries
    static let browseTitle = "Browse Countries"
    static let browseDone = "Done"
    static let browseLimitTitle = "Limit Reached"
    static let browseLimitMessage = "You can only select up to 5 countries."
    static let searchPlaceholder = "Search countries"
    
    // MARK: - Selected Countries
    static let selectedCountriesTitle = "Selected Countries"
    static let noSelectionTitle = "No countries selected."
    static let noSelectionSubtitle = "Browse and select up to 5 countries."
    static let browseButtonTitle = "Browse Countries"
    static let capitalPrefix = "Capital:"
    
    // MARK: - Country Detail
    static let countryDetailsTitle = "Country Details"
    static let labelCapital = "Capital"
    static let labelCurrency = "Currency"
    static let labelCoordinates = "Coordinates"
    
    // MARK: - Loading / General
    static let loading = "Loading..."
    static let ok = "OK"
    
    // MARK: - CoreData Model
    static let coreDataModelName = "CountryExplorerModel"
    
    // MARK: - Fatal Error Messages    
    static let coreDataLoadError = "Unresolved Core Data error"
    static let coreDataSaveError = "Unresolved Core Data save error"
}
