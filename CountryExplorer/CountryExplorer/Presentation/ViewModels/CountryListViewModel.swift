//
//  CountryListViewModel.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import Combine

@MainActor
final class CountryListViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var selectedCountries: [Country] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var searchText: String = ""
    @Published var debouncedSearchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let fetchCountriesUseCase: FetchCountriesUseCaseProtocol
    private let localDataSource: CountryLocalDataSourceProtocol
    private let networkMonitor: NetworkMonitor
    
    init(
        fetchCountriesUseCase: FetchCountriesUseCaseProtocol = FetchCountriesUseCase(),
        localDataSource: CountryLocalDataSourceProtocol = CountryLocalDataSource(),
        networkMonitor: NetworkMonitor = .shared
    ) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
        self.localDataSource = localDataSource
        self.networkMonitor = networkMonitor
        setupDebounce()
    }
    
    func fetchCountries() async {
        isLoading = true
        errorMessage = nil
        
        if networkMonitor.isConnected {
            do {
                let remoteCountries = try await fetchCountriesUseCase.execute()
                countries = remoteCountries
                localDataSource.save(countries: remoteCountries)
            } catch {
                countries = localDataSource.getCachedCountries()
                errorMessage = "Loaded from cache due to network issue."
            }
        } else {
            countries = localDataSource.getCachedCountries()
            errorMessage = "You are offline. Displaying cached data."
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
    
    private func setupDebounce() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: &$debouncedSearchText)
    }
    
    var filteredCountries: [Country] {
        if debouncedSearchText.isEmpty {
            return countries
        } else {
            return countries.filter {
                $0.name.localizedCaseInsensitiveContains(debouncedSearchText)
            }
        }
    }
}
