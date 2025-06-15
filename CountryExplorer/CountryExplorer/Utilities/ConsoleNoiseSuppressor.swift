//
//  ConsoleNoiseSuppressor.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

#if DEBUG
import os

extension OSLog {
    static let disabled = OSLog(subsystem: "com.apple", category: .pointsOfInterest)
}
#endif
