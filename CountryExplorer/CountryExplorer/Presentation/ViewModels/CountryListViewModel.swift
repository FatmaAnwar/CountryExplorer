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
    @Published private(set) var countries: [Country] = []
    @Published private(set) var selectedCountries: [Country] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published var searchText: String = ""
    @Published private(set) var debouncedSearchText: String = ""
    
    private let fetchCountriesUseCase: FetchCountriesUseCaseProtocol
    private let localDataSource: CountryLocalDataSourceProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private let debounceInterval: RunLoop.SchedulerTimeType.Stride
    
    private var cancellables = Set<AnyCancellable>()
    
    var filteredCountries: [Country] {
        debouncedSearchText.isEmpty
        ? countries
        : countries.filter { $0.name.localizedCaseInsensitiveContains(debouncedSearchText) }
    }
    
    init(
        fetchCountriesUseCase: FetchCountriesUseCaseProtocol = FetchCountriesUseCase(),
        localDataSource: CountryLocalDataSourceProtocol = CountryLocalDataSource(),
        networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
        debounceInterval: RunLoop.SchedulerTimeType.Stride = .milliseconds(300)
    ) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
        self.localDataSource = localDataSource
        self.networkMonitor = networkMonitor
        self.debounceInterval = debounceInterval
        
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
                errorMessage = AppStrings.networkFallbackMessage
            }
        } else {
            countries = localDataSource.getCachedCountries()
            errorMessage = AppStrings.offlineMessage
        }
        
        isLoading = false
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
    
    func cancelObservers() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func setupDebounce() {
        $searchText
            .debounce(for: debounceInterval, scheduler: RunLoop.main)
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
}
