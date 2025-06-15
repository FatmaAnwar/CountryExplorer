//
//  GradientSearchBar.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI

struct GradientSearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: AppStrings.searchIcon)
                .foregroundColor(.gray)
                .accessibilityHidden(true)
            
            TextField(AppStrings.searchPlaceholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
                .padding(.vertical, 8)
                .font(.body)
                .dynamicTypeSize(.medium ... .accessibility2)
                .accessibilityLabel(AppStrings.searchPlaceholder)
                .accessibilityHint(AppStrings.accessibilityHintSearch)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: AppStrings.clearIcon)
                        .foregroundColor(.gray)
                }
                .accessibilityLabel(AppStrings.accessibilityClearSearchLabel)
                .accessibilityHint(AppStrings.accessibilityHintClearSearch)
            }
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: isFocused ? 2.5 : 1.5
                )
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .padding(.horizontal)
        .padding(.top, 12)
    }
}
