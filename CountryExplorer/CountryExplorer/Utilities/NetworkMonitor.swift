//
//  NetworkMonitor.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import Network
import Combine

final class NetworkMonitor: NetworkMonitorProtocol {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: AppStrings.networkMonitorQueueLabel)
    
    @Published private(set) var isConnected: Bool = true
    
    var isConnectedSync: Bool {
        monitor.currentPath.status == .satisfied
    }
    
    private init() {
        self.monitor = NWPathMonitor()
        self.monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        self.monitor.start(queue: queue)
    }
}
