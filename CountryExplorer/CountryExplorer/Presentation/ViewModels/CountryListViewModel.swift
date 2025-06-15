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
        observeSelectionChanges()
        loadSelectedCountries()
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
    
    func select(_ country: Country) {
        guard !selectedCountries.contains(where: { $0.id == country.id }) else { return }
        selectedCountries.append(country)
    }
    
    func loadSelectedCountries() {
        selectedCountries = localDataSource.getSelectedCountries()
    }
    
    private func setupDebounce() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: &$debouncedSearchText)
    }
    
    private func observeSelectionChanges() {
        $selectedCountries
            .dropFirst()
            .sink { [weak self] updated in
                self?.localDataSource.saveSelectedCountries(updated)
            }
            .store(in: &cancellables)
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
    
    func toggleSelection(_ country: Country) -> Bool {
        if let index = selectedCountries.firstIndex(where: { $0.alpha2Code == country.alpha2Code }) {
            selectedCountries.remove(at: index)
            return true
        } else if selectedCountries.count < 5 {
            selectedCountries.append(country)
            return true
        } else {
            return false
        }
    }
}
