//
//  MockNetworkMonitor.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
@testable import CountryExplorer

final class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected: Bool
    var isConnectedSync: Bool
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
        self.isConnectedSync = isConnected
    }
}
