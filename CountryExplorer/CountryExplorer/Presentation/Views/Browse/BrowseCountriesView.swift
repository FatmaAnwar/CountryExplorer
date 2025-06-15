//
//  BrowseCountriesView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI
import Combine

struct BrowseCountriesView: View {
    @ObservedObject var viewModel: CountryListViewModel
    let onDone: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.gradientBackground()
                VStack(spacing: 0) {
                    GradientSearchBar(text: $viewModel.searchText)
                    
                    if viewModel.isLoading {
                        LoadingView()
                    } else {
                        CountryListSection(
                            countries: viewModel.filteredCountries,
                            selectedCountries: viewModel.selectedCountries,
                            onToggle: viewModel.toggleSelection(_:)
                        )
                        .padding(.top)
                    }
                }
            }
            .navigationTitle(AppStrings.browseTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AppStrings.browseDone, action: onDone)
                }
            }
            .overlay {
                if viewModel.didReachSelectionLimit {
                    BrowseAlertOverlay(
                        isVisible: $viewModel.didReachSelectionLimit,
                        title: AppStrings.browseLimitTitle,
                        message: AppStrings.browseLimitMessage
                    )
                }
            }
            .task {
                if viewModel.countries.isEmpty {
                    await viewModel.fetchCountries()
                }
            }
        }
    }
}
