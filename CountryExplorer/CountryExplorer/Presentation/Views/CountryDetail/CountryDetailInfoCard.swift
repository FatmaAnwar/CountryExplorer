//
//  CountryDetailInfoCard.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct CountryDetailInfoCard: View {
    let country: Country
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DetailRow(label: AppStrings.labelCapital, value: country.capital ?? "-")
            DetailRow(label: AppStrings.labelCurrency, value: country.currencyDescription)
            DetailRow(label: AppStrings.labelCoordinates, value: country.coordinateDescription)
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6)
        .padding(.horizontal)
    }
}
