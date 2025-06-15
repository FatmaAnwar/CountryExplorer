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

                VStack(alignment: .leading, spacing: 4) {
                    Text(country.name)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let capital = country.capital {
                        Text("\(AppStrings.capitalPrefix) \(capital)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                Image(systemName: AppStrings.trash)
                    .gradientForeground()
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
    }
}
