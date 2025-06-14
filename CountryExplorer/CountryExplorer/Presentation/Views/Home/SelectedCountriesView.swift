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
                        Text("No countries selected.")
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.selectedCountries, id: \.id) { country in
                                    HStack {
                                        Text(country.flag)
                                            .font(.title2)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(country.name)
                                                .font(.headline)
                                            if let capital = country.capital {
                                                Text("Capital: \(capital)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            viewModel.remove(country)
                                        }) {
                                            Image(systemName: "trash")
                                                .font(.system(size: 20))
                                                .padding(10)
                                                .background(Color.white)
                                                .foregroundColor(.red)
                                                .clipShape(Circle())
                                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(14)
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingBrowse = true
                    }) {
                        Text("Browse Countries")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.3, green: 0.6, blue: 1.0),
                                        Color(red: 0.7, green: 0.4, blue: 1.0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                    .sheet(isPresented: $isShowingBrowse) {
                        BrowseCountriesView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Selected Countries")
            .task {
                await viewModel.fetchCountries()
            }
        }
    }
}
