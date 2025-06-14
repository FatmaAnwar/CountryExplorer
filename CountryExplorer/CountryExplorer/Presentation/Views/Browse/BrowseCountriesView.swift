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
            List {
                ForEach(filteredCountries, id: \.id) { country in
                    HStack {
                        VStack(alignment: .leading) {
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
                            if let index = viewModel.selectedCountries.firstIndex(where: { $0.alpha2Code == country.alpha2Code }) {
                                viewModel.selectedCountries.remove(at: index)
                            } else {
                                if viewModel.selectedCountries.count < 5 {
                                    viewModel.selectedCountries.append(country)
                                } else {
                                    showAlert = true
                                }
                            }
                        } label: {
                            Image(systemName: viewModel.selectedCountries.contains(where: { $0.alpha2Code == country.alpha2Code }) ? "checkmark.circle.fill" : "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(viewModel.selectedCountries.contains(where: { $0.alpha2Code == country.alpha2Code }) ? .green : .blue)
                                .padding(.trailing, 4)
                        }
                        
                    }
                    .padding(.vertical, 6)
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
