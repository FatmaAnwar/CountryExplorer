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
                CountryDetailHeader(country: country)
                CountryDetailInfoCard(country: country)
                
                if country.coordinate != nil {
                    CountryDetailMapView(region: $region, country: country)
                }
            }
            .padding(.top, 30)
        }
        .navigationTitle(AppStrings.countryDetailsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.clear.gradientBackground())
    }
}
