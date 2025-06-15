//
//  CountryDetailMapView.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI
import MapKit

struct CountryDetailMapView: View {
    @Binding var region: MKCoordinateRegion
    let country: Country
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: annotationItems) { item in
            MapMarker(coordinate: item.coordinate)
        }
        .frame(height: 250)
        .cornerRadius(16)
        .padding(.horizontal)
        .shadow(radius: 6)
        .accessibilityElement()
        .accessibilityLabel("\(AppStrings.accessibilityLabelMapPrefix) \(country.name)")
    }
    
    private var annotationItems: [CountryAnnotationItem] {
        guard let coordinate = country.coordinate else { return [] }
        return [CountryAnnotationItem(id: country.id, coordinate: coordinate)]
    }
}
