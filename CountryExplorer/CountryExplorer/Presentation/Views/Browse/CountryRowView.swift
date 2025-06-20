//
//  CountryRowView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct CountryRowView: View {
    let country: Country
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Text(country.flag)
                .font(.title2)
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(country.name)
                    .font(.headline)
                    .dynamicTypeSize(.medium ... .accessibility2)
                
                if let capital = country.capital {
                    Text(capital)
                        .font(.subheadline)
                        .dynamicTypeSize(.medium ... .accessibility2)
                        .foregroundColor(.gray)
                        .accessibilityLabel("\(AppStrings.capitalPrefix) \(capital)")
                }
            }
            
            Spacer()
            
            Image(systemName: isSelected ? AppStrings.checkmarkCircle : AppStrings.plusCircle)
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(isSelected ? .green : .blue)
                .accessibilityHidden(true)
        }
        .padding()
        .background(isSelected ? Color.green.opacity(0.15) : Color("CardBackground"))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
        .onTapGesture {
            onTap()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(country.name)
        .accessibilityValue(isSelected ? AppStrings.accessibilityValueSelected : AppStrings.accessibilityValueNotSelected)
        .accessibilityHint(AppStrings.accessibilityHintSelectCountry)
    }
}
