//
//  NetworkService.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import Network
import Combine

protocol NetworkService {
    var isConnected: Published<Bool>.Publisher { get }
}

final class NetworkServiceImpl: NetworkService {
    
    // MARK: - Stored Properties
    
    private let monitor = NWPathMonitor()
    
    @Published var isConnectedValue: Bool = false
    var isConnected: Published<Bool>.Publisher { $isConnectedValue }
    
    // MARK: - Initialization
    
    init() {
        setup()
        observeState()
    }
    
    // MARK: - Methods
    
    internal func observeState() {
        self.monitor.pathUpdateHandler = {
            self.isConnectedValue = $0.status == .satisfied
        }
    }
    
    private func setup() {
        let queue = DispatchQueue(label: "NWPathMonitor")
        monitor.start(queue: queue)
    }
    
}
