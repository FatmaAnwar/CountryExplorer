//
//  String+Constants.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation

enum AppStrings {
    
    // MARK: - Titles
    static let selectedCountriesTitle = "Selected Countries"
    static let browseTitle = "Browse Countries"
    static let countryDetailsTitle = "Country Details"
    
    // MARK: - Buttons
    static let browseButtonTitle = "Browse Countries"
    static let browseDone = "Done"
    static let ok = "OK"
    
    // MARK: - Browse Limits
    static let browseLimitTitle = "Limit Reached"
    static let browseLimitMessage = "You can only select up to 5 countries."
    
    // MARK: - Placeholders
    static let searchPlaceholder = "Search countries"
    
    // MARK: - Empty State
    static let noSelectionTitle = "No countries selected."
    static let noSelectionSubtitle = "Browse and select up to 5 countries."
    
    // MARK: - Labels
    static let capitalPrefix = "Capital:"
    static let labelCapital = "Capital"
    static let labelCurrency = "Currency"
    static let labelCoordinates = "Coordinates"
    
    // MARK: - Loading
    static let loading = "Loading..."
    
    // MARK: - System images
    static let globe = "globe.europe.africa.fill"
    static let searchIcon = "magnifyingglass"
    static let clearIcon = "xmark.circle.fill"
    static let trash = "trash"
    static let checkmarkCircle = "checkmark.circle.fill"
    static let plusCircle = "plus.circle.fill"
    
    // MARK: - Core Data
    static let coreDataModelName = "CountryExplorerModel"
    static let coreDataLoadError = "Unresolved Core Data load error"
    static let coreDataSaveError = "Unresolved Core Data save error"
    
    // MARK: - API Endpoints
    static let apiAllCountriesEndpoint = "https://restcountries.com/v2/all?fields=name,capital,currencies,alpha2Code,latlng"
    
    // MARK: - Network
    static let networkMonitorQueueLabel = "NetworkMonitorQueue"
    static let networkFallbackMessage = "Loaded from cache due to network issue."
    static let offlineMessage = "You are offline. Displaying cached data."
}
