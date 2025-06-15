//
//  GradientBackground.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI

extension View {
    func gradientBackground() -> some View {
        modifier(GradientBackgroundModifier())
    }
}

private struct GradientBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                Group {
                    if colorScheme == .dark {
                        Color.black.ignoresSafeArea()
                    } else {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.90, green: 0.95, blue: 1.0),
                                .white
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                    }
                }
            )
    }
}
