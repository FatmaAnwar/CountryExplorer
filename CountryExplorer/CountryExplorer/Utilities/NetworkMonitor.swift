//
//  NetworkMonitor.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published private(set) var isConnected: Bool = true
    
    var isConnectedSync: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    private init() {
        self.monitor = NWPathMonitor()
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        self.monitor.start(queue: queue)
    }
}
