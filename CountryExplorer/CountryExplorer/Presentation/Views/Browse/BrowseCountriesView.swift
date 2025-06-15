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
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredCountries, id: \.id) { country in
                                    CountryRowView(
                                        country: country,
                                        isSelected: isSelected(country),
                                        onTap: { toggleSelection(for: country) }
                                    )
                                }
                            }
                            .padding(.top)
                        }
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
                Group {
                    if showAlert {
                        ZStack {
                            Color.black.opacity(0.3).ignoresSafeArea()
                            GradientAlertView(
                                title: AppStrings.browseLimitTitle,
                                message: AppStrings.browseLimitMessage
                            ) {
                                showAlert = false
                            }
                        }
                    }
                }
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
    
    private func isSelected(_ country: Country) -> Bool {
        viewModel.selectedCountries.contains { $0.alpha2Code == country.alpha2Code }
    }
    
    private func toggleSelection(for country: Country) {
        if let index = viewModel.selectedCountries.firstIndex(where: { $0.alpha2Code == country.alpha2Code }) {
            viewModel.selectedCountries.remove(at: index)
        } else if viewModel.selectedCountries.count < 5 {
            viewModel.selectedCountries.append(country)
        } else {
            showAlert = true
        }
    }
}
