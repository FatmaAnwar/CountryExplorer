//
//  SelectedCountriesView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct SelectedCountriesView: View {
    @ObservedObject var viewModel: CountryListViewModel
    
    let onBrowseTap: () -> Void
    let onCountrySelected: (Country) -> Void
    let onCountryRemoved: (Country) -> Void
    
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
                                        onDelete: { onCountryRemoved(country) },
                                        onTap: { onCountrySelected(country) }
                                    )
                                }
                            }
                            .padding(.top)
                        }
                    }
                    
                    SelectedBrowseButton(onTap: onBrowseTap)
                        .padding(.bottom, 20)
                }
            }
            .navigationTitle(AppStrings.selectedCountriesTitle)
            .task {
                await viewModel.fetchCountries()
            }
        }
    }
}
