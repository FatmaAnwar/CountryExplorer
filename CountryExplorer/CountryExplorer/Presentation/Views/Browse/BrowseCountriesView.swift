//
//  BrowseCountriesView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI

struct BrowseCountriesView: View {
    @ObservedObject var viewModel: CountryListViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.gradientBackground()
                
                VStack(spacing: 0) {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredCountries, id: \.id) { country in
                                HStack {
                                    Text(country.flag)
                                        .font(.title2)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(country.name)
                                            .font(.headline)
                                        if let capital = country.capital {
                                            Text(capital)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: isSelected(country) ? "checkmark.circle.fill" : "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                        .foregroundColor(isSelected(country) ? .green : .blue)
                                }
                                .padding()
                                .background(isSelected(country) ? Color.green.opacity(0.15) : Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .padding(.horizontal)
                                .onTapGesture {
                                    toggleSelection(for: country)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Browse Countries")
            .searchable(text: $searchText, prompt: "Search countries")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Limit Reached"),
                    message: Text("You can only select up to 5 countries."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func isSelected(_ country: Country) -> Bool {
        viewModel.selectedCountries.contains { $0.alpha2Code == country.alpha2Code }
    }
    
    private func toggleSelection(for country: Country) {
        if let index = viewModel.selectedCountries.firstIndex(where: { $0.alpha2Code == country.alpha2Code }) {
            viewModel.selectedCountries.remove(at: index)
        } else if viewModel.selectedCountries.count < 5 {
            viewModel.selectedCountries.append(country)
        } else {
            showAlert = true
        }
    }
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return viewModel.countries
        } else {
            return viewModel.countries.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
