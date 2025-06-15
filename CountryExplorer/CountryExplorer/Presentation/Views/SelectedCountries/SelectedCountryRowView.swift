//
//  SelectedCountryRowView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct SelectedCountriesView: View {
    @StateObject private var viewModel = CountryListViewModel()
    @State private var isShowingBrowse = false
    @State private var selectedCountryForDetail: Country?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.gradientBackground()
                
                VStack(spacing: 0) {
                    if viewModel.selectedCountries.isEmpty {
                        SelectedEmptyStateView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.selectedCountries, id: \.id) { country in
                                    SelectedCountryCardView(
                                        country: country,
                                        onDelete: {
                                            viewModel.remove(country)
                                        },
                                        onTap: {
                                            selectedCountryForDetail = country
                                        }
                                    )
                                }
                            }
                            .padding(.top)
                        }
                    }
                    
                    SelectedBrowseButton {
                        isShowingBrowse = true
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle(AppStrings.selectedCountriesTitle)
            .navigationDestination(item: $selectedCountryForDetail) { country in
                CountryDetailView(country: country)
            }
            .sheet(isPresented: $isShowingBrowse) {
                BrowseCountriesView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchCountries()
            }
        }
    }
}
