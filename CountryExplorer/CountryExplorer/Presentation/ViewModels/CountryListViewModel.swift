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
}
