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
    @Published var didReachSelectionLimit = false
    
    private let fetchCountriesUseCase: FetchCountriesUseCaseProtocol
    private let localDataSource: CountryLocalDataSourceProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private let locationManager: CountryLocationManagerProtocol
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
        locationManager: CountryLocationManagerProtocol = CountryLocationManager(),
        debounceInterval: RunLoop.SchedulerTimeType.Stride = .milliseconds(300)
    ) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
        self.localDataSource = localDataSource
        self.networkMonitor = networkMonitor
        self.locationManager = locationManager
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
        
        loadSelectedCountries()
        
        if selectedCountries.isEmpty {
            await autoSelectBasedOnLocation()
            loadSelectedCountries()
        }
        
        isLoading = false
    }
    
    private func autoSelectBasedOnLocation() async {
        await withCheckedContinuation { continuation in
            locationManager.getUserCountryCode { [weak self] code in
                guard let self else {
                    continuation.resume()
                    return
                }
                
                let lowercasedCode = code?.lowercased()
                
                if let code = lowercasedCode,
                   let match = self.countries.first(where: { $0.alpha2Code.lowercased() == code }) {
                    self.setSelectedCountry(match)
                } else {
                    if let egypt = self.countries.first(where: { $0.alpha2Code.lowercased() == "eg" }) {
                        self.setSelectedCountry(egypt)
                    }
                }
                
                continuation.resume()
            }
        }
    }
    
    func toggleSelection(_ country: Country) {
        if let idx = selectedCountries.firstIndex(where: { $0.alpha2Code == country.alpha2Code }) {
            selectedCountries.remove(at: idx)
            
            if selectedCountries.isEmpty {
                Task {
                    await autoSelectBasedOnLocation()
                }
            }
        } else if selectedCountries.count < 5 {
            selectedCountries.append(country)
        } else {
            didReachSelectionLimit = true
        }
    }
    
    func loadSelectedCountries() {
        selectedCountries = localDataSource.getSelectedCountries()
    }
    
    private func setSelectedCountry(_ country: Country) {
        self.selectedCountries = [country]
        self.localDataSource.saveSelectedCountries([country])
    }
    
#if DEBUG
    func _injectCountriesForTesting(_ countries: [Country]) {
        self.countries = countries
    }
#endif
}
