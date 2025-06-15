//
//  BrowseAlertOverlay.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct BrowseAlertOverlay: View {
    @Binding var isVisible: Bool
    let title: String
    let message: String
    
    var body: some View {
        Group {
            if isVisible {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    GradientAlertView(
                        title: title,
                        message: message,
                        onDismiss: { isVisible = false }
                    )
                }
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isModal)
            }
        }
    }
}
