//
//  CountryDetailView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI

struct CountryDetailView: View {
    let country: Country
    
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Text(country.flag)
                    .font(.system(size: 120))
                    .shadow(radius: 4)
                
                Text(country.name)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 20) {
                    DetailRow(label: "Capital", value: country.capital ?? "N/A")
                    DetailRow(label: "Currency", value: formattedCurrency())
                    DetailRow(label: "Coordinates", value: formattedCoordinates())
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 40)
        }
        .gradientBackground()
        .navigationTitle("Country Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formattedCurrency() -> String {
        guard let currency = country.currencies?.first else { return "N/A" }
        let code = currency.code ?? ""
        let name = currency.name ?? "Unknown"
        return "\(name) (\(code))"
    }
    
    private func formattedCoordinates() -> String {
        guard let coords = country.latlng, coords.count == 2 else { return "N/A" }
        return String(format: "%.1f, %.1f", coords[0], coords[1])
    }
}
