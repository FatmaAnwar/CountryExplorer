//
//  CountryAnnotationItem.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import MapKit

struct CountryAnnotationItem: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
}
