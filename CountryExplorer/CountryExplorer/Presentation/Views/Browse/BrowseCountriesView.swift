//
//  BrowseCountriesView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI
import Combine

struct BrowseCountriesView: View {
    @ObservedObject var viewModel: CountryListViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.gradientBackground()
                
                VStack(spacing: 0) {
                    if viewModel.isLoading {
                        ZStack {
                            Color.black.opacity(0.2).ignoresSafeArea()
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.90, green: 0.95, blue: 1.0),
                                            Color.white
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(radius: 10)
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredCountries, id: \.id) { country in
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
            }
            .navigationTitle("Browse Countries")
            .searchable(text: $viewModel.searchText, prompt: "Search countries")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .overlay(
                Group {
                    if showAlert {
                        ZStack {
                            Color.black.opacity(0.3).ignoresSafeArea()
                            GradientAlertView(
                                title: "Limit Reached",
                                message: "You can only select up to 5 countries."
                            ) {
                                showAlert = false
                            }
                        }
                    }
                }
            )
            .onAppear {
                if viewModel.countries.isEmpty {
                    Task {
                        await viewModel.fetchCountries()
                    }
                }
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
}
