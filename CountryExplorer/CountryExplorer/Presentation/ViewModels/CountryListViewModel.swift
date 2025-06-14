//
//  CountryListViewModel.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation

@MainActor
final class CountryListViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var selectedCountries: [Country] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let fetchCountriesUseCase: FetchCountriesUseCaseProtocol
    
    init(fetchCountriesUseCase: FetchCountriesUseCaseProtocol = FetchCountriesUseCase()) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
    }
    
    func fetchCountries() async {
        isLoading = true
        errorMessage = nil
        
        do {
            countries = try await fetchCountriesUseCase.execute()
        } catch {
            errorMessage = "Failed to load countries: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func remove(_ country: Country) {
        selectedCountries.removeAll { $0.id == country.id }
    }
    
    func loadInitialSelection() {
        if selectedCountries.isEmpty {
            selectedCountries = Array(countries.prefix(5))
        }
    }
    
    func loadDummySelection() {
        selectedCountries = [
            Country(
                name: "France",
                capital: "Paris",
                currencies: [Country.Currency(code: "EUR", name: "Euro", symbol: "€")],
                alpha2Code: "FR",
                latlng: [48.8566, 2.3522]
            ),
            Country(
                name: "Japan",
                capital: "Tokyo",
                currencies: [Country.Currency(code: "JPY", name: "Yen", symbol: "¥")],
                alpha2Code: "JP",
                latlng: [35.6895, 139.6917]
            )
        ]
    }
}
