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
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.selectedCountries.isEmpty {
                    Text("No countries selected.")
                        .foregroundColor(.gray)
                        .padding(.top, 100)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.selectedCountries, id: \.id) { country in
                                HStack {
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
                                    Button {
                                        viewModel.remove(country)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("Browse Countries")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("Selected Countries")
            .task {
                // await viewModel.fetchCountries()
                viewModel.loadDummySelection()
            }
        }
    }
}
