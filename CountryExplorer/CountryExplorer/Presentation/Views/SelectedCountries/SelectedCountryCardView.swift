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
        HStack(spacing: 12) {
            Text(country.flag)
                .font(.title2)
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(country.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let capital = country.capital {
                    Text("\(AppStrings.capitalPrefix) \(capital)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .accessibilityLabel("\(AppStrings.capitalPrefix) \(capital)")
                }
            }
            
            Spacer()
            
            Button(action: onDelete) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: AppStrings.trash)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.purple)
                }
            }
            .accessibilityLabel("\(AppStrings.delete) \(country.name)")
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6)
        .padding(.horizontal)
        .onTapGesture {
            onTap()
        }
    }
}
