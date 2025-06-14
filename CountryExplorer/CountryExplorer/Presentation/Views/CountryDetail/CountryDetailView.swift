//
//  CountryDetailView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import SwiftUI
import MapKit

struct CountryDetailView: View {
    let country: Country
    
    @State private var region: MKCoordinateRegion
    
    init(country: Country) {
        self.country = country
        
        let latitude = country.latlng?.first ?? 0.0
        let longitude = country.latlng?.last ?? 0.0
        
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Flag & Country Name
                Text(country.flag)
                    .font(.system(size: 80))
                
                Text(country.name)
                    .font(.largeTitle)
                    .bold()
                
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(label: "Capital", value: country.capital ?? "-")
                    DetailRow(label: "Currency", value: country.currencyDescription)
                    DetailRow(label: "Coordinates", value: country.coordinateDescription)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 6)
                .padding(.horizontal)
                
                if let _ = country.coordinate {
                    Map(coordinateRegion: $region, annotationItems: [country]) { item in
                        MapMarker(coordinate: item.coordinate!)
                    }
                    .frame(height: 250)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .shadow(radius: 6)
                }
            }
            .padding(.top, 30)
        }
        .navigationTitle("Country Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.clear.gradientBackground())
    }
}
