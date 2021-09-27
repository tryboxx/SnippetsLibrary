//
//  StatusViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 27/09/2021.
//

import SwiftUI
import Combine

final class StatusViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    @Published internal var snippets: [Snippet] = []
    @Published internal var shouldShowRemoveAlert: Bool = false
    
    private let userDefaultsService: UserDefaultsService
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(userDefaultsService: UserDefaultsService = DIContainer.userDefaultsService) {
        self.userDefaultsService = userDefaultsService
        
        fetchSnippets()
    }
    
    // MARK: - Methods
    
    private func fetchSnippets() {
        userDefaultsService.fetchRecentSnippets()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] in
                self?.snippets = $0
            }
            .store(in: &cancellables)
    }
    
}
