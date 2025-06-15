//
//  SelectedCountryCardView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI

struct SelectedCountryCardView: View {
    let country: Country
    var onDelete: () -> Void
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(country.flag)
                    .font(.title2)
                    .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(country.name)
                        .font(.headline)
                        .dynamicTypeSize(.medium ... .accessibility2)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let capital = country.capital {
                        Text("\(AppStrings.capitalPrefix) \(capital)")
                            .font(.subheadline)
                            .dynamicTypeSize(.medium ... .accessibility2)
                            .foregroundColor(.gray)
                            .accessibilityLabel("\(AppStrings.capitalPrefix) \(capital)")
                    }
                }
                
                Spacer()
                
                Image(systemName: AppStrings.trash)
                    .gradientForeground()
                    .accessibilityHidden(true)
                    .onTapGesture {
                        onDelete()
                    }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3)
            .padding(.horizontal)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(country.name), \(country.capital ?? AppStrings.noSelectionTitle)")
        .accessibilityHint(AppStrings.accessibilityHintCountryCard)
    }
}
