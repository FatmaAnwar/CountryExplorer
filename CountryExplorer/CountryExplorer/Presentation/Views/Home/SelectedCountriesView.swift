//
//  SelectedCountriesView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI

struct SelectedCountriesView: View {
    @StateObject private var viewModel = CountryListViewModel()
    @State private var isShowingBrowse = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.gradientBackground()
                
                VStack {
                    if viewModel.selectedCountries.isEmpty {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .mask(
                                Image(systemName: "globe.europe.africa.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                            )
                            .frame(width: 80, height: 80)
                            
                            Text("No countries selected.")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxHeight: .infinity)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 40)
                        
                        GradientButton(title: "Browse Countries") {
                            isShowingBrowse = true
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                        
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(viewModel.selectedCountries, id: \.id) { country in
                                    SelectedCountryCard(country: country) {
                                        withAnimation(.spring()) {
                                            viewModel.remove(country)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 12)
                            .padding(.horizontal)
                        }
                        
                        GradientButton(title: "Browse Countries") {
                            isShowingBrowse = true
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                    }
                }
                .navigationTitle("Selected Countries")
                .sheet(isPresented: $isShowingBrowse) {
                    BrowseCountriesView(viewModel: viewModel)
                }
                .task {
                    await viewModel.fetchCountries()
                }
            }
        }
    }
}
