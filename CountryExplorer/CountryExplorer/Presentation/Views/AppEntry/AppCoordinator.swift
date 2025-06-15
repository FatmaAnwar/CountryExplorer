//
//  AppCoordinator.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published private(set) var countryListViewModel: CountryListViewModel?
    @Published var isShowingBrowse = false
    @Published var selectedCountry: Country?
    
    private let makeViewModel: () async -> CountryListViewModel
    
    init(makeViewModel: @escaping () async -> CountryListViewModel) {
        self.makeViewModel = makeViewModel
        Task {
            let vm = await makeViewModel()
            self.countryListViewModel = vm
            await vm.fetchCountries()
        }
    }
    
    convenience init() {
        self.init(makeViewModel: {
            let apiService = APIService()
            let remote = CountryRemoteDataSource(apiService: apiService)
            let useCase = FetchCountriesUseCase(remoteDataSource: remote)
            let local = CountryLocalDataSource()
            let monitor = NetworkMonitor.shared
            return CountryListViewModel(
                fetchCountriesUseCase: useCase,
                localDataSource: local,
                networkMonitor: monitor
            )
        })
    }
    
    func makeRootView() -> some View {
        NavigationStack {
            if let vm = countryListViewModel {
                SelectedCountriesView(
                    viewModel: vm,
                    onBrowseTap: { self.isShowingBrowse = true },
                    onCountrySelected: { self.selectedCountry = $0 },
                    onCountryRemoved: { vm.toggleSelection($0) }
                )
                .sheet(
                    isPresented: Binding(
                        get: { self.isShowingBrowse },
                        set: { self.isShowingBrowse = $0 }
                    )
                ) {
                    self.makeBrowseView()
                }
                .navigationDestination(
                    item: Binding(
                        get: { self.selectedCountry },
                        set: { self.selectedCountry = $0 }
                    )
                ) { country in
                    self.makeDetailView(for: country)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear.gradientBackground())
            }
        }
    }
    
    private func makeBrowseView() -> some View {
        guard let vm = countryListViewModel else {
            return AnyView(ProgressView())
        }
        return AnyView(
            BrowseCountriesView(
                viewModel: vm,
                onDone: { self.isShowingBrowse = false }
            )
        )
    }
    
    private func makeDetailView(for country: Country) -> some View {
        CountryDetailView(country: country)
    }
}
