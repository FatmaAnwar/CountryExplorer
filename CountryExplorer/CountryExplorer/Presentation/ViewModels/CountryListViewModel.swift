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
        
        $searchText
            .debounce(for: debounceInterval, scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: &$debouncedSearchText)
        
        $selectedCountries
            .dropFirst()
            .sink { [weak self] updated in
                self?.localDataSource.saveSelectedCountries(updated)
            }
            .store(in: &cancellables)
        
        loadSelectedCountries()
    }
    
    func fetchCountries() async {
        isLoading = true
        errorMessage = nil
        
        if networkMonitor.isConnected {
            do {
                let remote = try await fetchCountriesUseCase.execute()
                countries = remote
                localDataSource.save(countries: remote)
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
    
    func toggleSelection(_ country: Country) {
        if let idx = selectedCountries.firstIndex(where: { $0.alpha2Code == country.alpha2Code }) {
            selectedCountries.remove(at: idx)
        } else if selectedCountries.count < 5 {
            selectedCountries.append(country)
        } else {
            didReachSelectionLimit = true
        }
    }
    
    func loadSelectedCountries() {
        selectedCountries = localDataSource.getSelectedCountries()
    }
}
