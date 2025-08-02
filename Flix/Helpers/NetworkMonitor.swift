//
//  NetworkMonitor.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import Foundation
import Network
import RxSwift
import RxRelay
import RxCocoa

final class NetworkMonitor {
    
    // MARK: - Singleton
    static let shared = NetworkMonitor()
    
    // MARK: - Private Properties
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let isConnectedRelay = BehaviorRelay<Bool>(value: true) // Assume conectado por padrão
    
    // MARK: - Public Properties
    var isConnected: Driver<Bool> {
        isConnectedRelay.asDriver()
    }
    
    var isConnectedValue: Bool {
        isConnectedRelay.value
    }
    
    // MARK: - Init
    private init() {
        setupMonitoring()
    }
    
    // MARK: - Private Methods
    private func setupMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            print("🌐 Network status changed: \(isConnected ? "Connected" : "Disconnected")")
            self?.isConnectedRelay.accept(isConnected)
        }
        
        monitor.start(queue: queue)
    }
    
    // MARK: - Public Methods
    func startMonitoring() {
        print("🌐 Starting network monitoring...")
    }
    
    func stopMonitoring() {
        print("🌐 Stopping network monitoring...")
        monitor.cancel()
    }
    
    func checkConnection() -> Bool {
        return isConnectedValue
    }
    
    func getConnectionType() -> String {
        let path = monitor.currentPath
        
        if path.usesInterfaceType(.wifi) {
            return "WiFi"
        } else if path.usesInterfaceType(.cellular) {
            return "Cellular"
        } else if path.usesInterfaceType(.wiredEthernet) {
            return "Ethernet"
        } else {
            return "Other"
        }
    }
    
    deinit {
        stopMonitoring()
    }
} 
