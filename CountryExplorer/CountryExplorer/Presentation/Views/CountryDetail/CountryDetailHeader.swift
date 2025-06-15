//
//  CountryDetailHeader.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import SwiftUI

struct CountryDetailHeader: View {
    let country: Country
    
    var body: some View {
        VStack(spacing: 8) {
            Text(country.flag)
                .font(.system(size: 80))
            
            Text(country.name)
                .font(.largeTitle)
                .bold()
        }
    }
}
