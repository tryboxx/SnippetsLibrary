//
//  NetworkObserver.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import Foundation
import Combine

final class NetworkObserver: ObservableObject {
    
    // MARK: - Stored Porperties
    
    @Published var isConnected = true
    
    private let networkService: NetworkService
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(networkService: NetworkService = DIContainer.networkServcie) {
        self.networkService = networkService
        
        observeNetworkState()
    }
    
    // MARK: - Methods
    
    private func observeNetworkState() {
        networkService.isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.isConnected = $0
            }
            .store(in: &cancellables)
    }
    
}
