//
//  SelectedEmptyStateView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct SelectedEmptyStateView: View {
    var body: some View {
        Spacer()
        VStack(spacing: 12) {
            Image(systemName: AppStrings.globe)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .gradientForeground()
                .accessibilityHidden(true)
            
            Text(AppStrings.noSelectionTitle)
                .font(.headline)
                .foregroundColor(.gray)
                .accessibilityLabel(AppStrings.accessibilityLabelNoSelection)
                .accessibilityHint(AppStrings.accessibilityHintNoSelection)
        }
        .padding()
        Spacer()
    }
}
