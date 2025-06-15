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
            Image(systemName: "globe.europe.africa.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .gradientForeground()
            
            Text(AppStrings.noSelectionTitle)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
        Spacer()
    }
}
