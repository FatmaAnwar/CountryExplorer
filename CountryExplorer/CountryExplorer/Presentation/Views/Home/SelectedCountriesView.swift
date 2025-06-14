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
    @State private var selectedCountryForDetail: Country?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.gradientBackground()
                
                VStack(spacing: 0) {
                    if viewModel.selectedCountries.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "globe.europe.africa.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .gradientForeground()
                            
                            Text("No countries selected.")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.selectedCountries, id: \.id) { country in
                                    Button {
                                        selectedCountryForDetail = country
                                    } label: {
                                        HStack(spacing: 12) {
                                            Text(country.flag)
                                                .font(.title2)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(country.name)
                                                    .font(.headline)
                                                    .foregroundColor(.blue)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                if let capital = country.capital {
                                                    Text("Capital: \(capital)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "trash")
                                                .gradientForeground()
                                                .onTapGesture {
                                                    viewModel.remove(country)
                                                }
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.05), radius: 3)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.top)
                        }
                    }
                    
                    Button(action: {
                        isShowingBrowse = true
                    }) {
                        Text("Browse Countries")
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
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Selected Countries")
            .navigationDestination(item: $selectedCountryForDetail) { country in
                CountryDetailView(country: country)
            }
            .sheet(isPresented: $isShowingBrowse) {
                BrowseCountriesView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchCountries()
            }
        }
    }
}

