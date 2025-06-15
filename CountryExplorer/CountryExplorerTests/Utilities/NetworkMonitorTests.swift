//
//  NetworkMonitorTests.swift
//  CountryExplorerTests
//
//  Created by Fatma Anwar on 15/06/2025.
//

import Foundation
import XCTest
@testable import CountryExplorer

final class NetworkMonitorTests: XCTestCase {
    
    func test_isConnectedSync_returnsTrueForSatisfiedPath() {
        // Given
        let sut = MockNetworkMonitor(isConnected: true)
        
        // When
        let result = sut.isConnectedSync
        
        // Then
        XCTAssertTrue(result)
    }
    
    func test_isConnectedSync_returnsFalseForUnsatisfiedPath() {
        // Given
        let sut = MockNetworkMonitor(isConnected: false)
        
        // When
        let result = sut.isConnectedSync
        
        // Then
        XCTAssertFalse(result)
    }
    
    func test_isConnected_returnsPublishedValue() {
        // Given
        let sut = MockNetworkMonitor(isConnected: false)
        
        // Then
        XCTAssertFalse(sut.isConnected)
    }
}
