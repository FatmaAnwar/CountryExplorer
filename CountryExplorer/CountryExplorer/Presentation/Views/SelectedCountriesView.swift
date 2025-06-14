//
//  SelectedCountriesView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI

struct SelectedCountriesView: View {
    @StateObject private var viewModel = CountryListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.countries) { country in
                Text(country.name)
            }
            .navigationTitle("Countries")
            .task {
                await viewModel.fetchCountries()
            }
        }
    }
}
