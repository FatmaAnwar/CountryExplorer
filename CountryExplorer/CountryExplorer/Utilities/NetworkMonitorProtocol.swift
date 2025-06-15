//
//  NetworkMonitorProtocol.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    var isConnectedSync: Bool { get }
}
