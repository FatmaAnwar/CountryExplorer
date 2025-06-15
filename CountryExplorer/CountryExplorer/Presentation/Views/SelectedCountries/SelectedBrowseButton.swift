//
//  SelectedBrowseButton.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct SelectedBrowseButton: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(AppStrings.browseButtonTitle)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
        }
        .accessibilityLabel(AppStrings.browseButtonTitle)
        .accessibilityHint(AppStrings.accessibilityHintBrowseCountries)
    }
}
