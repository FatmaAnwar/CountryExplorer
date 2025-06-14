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
            VStack(spacing: 24) {
                Text(country.flag)
                    .font(.system(size: 100))
                
                Text(country.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                if let capital = country.capital {
                    detailRow(title: "Capital", value: capital)
                }
                
                if let currencies = country.currencies, !currencies.isEmpty {
                    detailRow(title: "Currency", value: currencies.map { "\($0.name ?? "") (\($0.code ?? ""))" }.joined(separator: ", "))
                }
                
                if let coords = country.latlng, coords.count == 2 {
                    detailRow(title: "Coordinates", value: "\(coords[0]), \(coords[1])")
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .gradientBackground()
        .navigationTitle("Country Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text("\(title):")
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal)
    }
}
