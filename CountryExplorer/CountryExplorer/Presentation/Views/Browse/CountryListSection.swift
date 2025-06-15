//
//  CountryListSection.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct CountryListSection: View {
    let countries: [Country]
    let selectedCountries: [Country]
    let onToggle: (Country) -> Void
    
    private func isSelected(_ country: Country) -> Bool {
        selectedCountries.contains { $0.alpha2Code == country.alpha2Code }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(countries, id: \.id) { country in
                    CountryRowView(
                        country: country,
                        isSelected: isSelected(country),
                        onTap: { onToggle(country) }
                    )
                }
            }
        }
    }
}
