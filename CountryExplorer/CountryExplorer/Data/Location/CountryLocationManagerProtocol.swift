//
//  CountryLocationManagerProtocol.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import CoreLocation

protocol CountryLocationManagerProtocol {
    func getUserCountryCode(completion: @escaping (String?) -> Void)
}
