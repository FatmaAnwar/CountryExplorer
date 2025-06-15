//
//  CountryExplorerApp.swift
//  CountryExplorer
//
//  Created by Fatma Anwar on 14/06/2025.
//

import SwiftUI

@main
struct CountryExplorerApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.makeRootView()
        }
    }
}
