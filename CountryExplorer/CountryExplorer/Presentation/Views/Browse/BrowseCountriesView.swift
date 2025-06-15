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
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert: Bool = false
    
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
                            onToggle: toggleSelection(for:)
                        )
                        .padding(.top)
                    }
                }
            }
            .navigationTitle(AppStrings.browseTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AppStrings.browseDone) {
                        dismiss()
                    }
                }
            }
            .overlay(
                BrowseAlertOverlay(
                    isVisible: $showAlert,
                    title: AppStrings.browseLimitTitle,
                    message: AppStrings.browseLimitMessage
                )
            )
            .onAppear {
                if viewModel.countries.isEmpty {
                    Task {
                        await viewModel.fetchCountries()
                    }
                }
            }
        }
    }
    
    private func toggleSelection(for country: Country) {
        let success = viewModel.toggleSelection(country)
        if !success {
            showAlert = true
        }
    }
}
