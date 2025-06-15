//
//  LoadingView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.90, green: 0.95, blue: 1.0),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
                
                Text(AppStrings.loading)
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(32)
            .background(Color.white.opacity(0.95))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}
