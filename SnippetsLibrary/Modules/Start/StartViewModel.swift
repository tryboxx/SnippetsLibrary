//
//  StartViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI
import Combine

final class StartViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    @Published internal var recentSnippets: [Snippet] = []
    
    @Binding internal var activeAppView: ActiveAppView?
    @Binding internal var activeAppSheet: AppSheet?
    
    private let userDefaultsService: UserDefaultsService
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(
        activeAppView: Binding<ActiveAppView?>,
        activeAppSheet: Binding<AppSheet?>,
        userDefaultsService: UserDefaultsService = DIContainer.userDefaultsService
    ) {
        self._activeAppView = activeAppView
        self._activeAppSheet = activeAppSheet
        self.userDefaultsService = userDefaultsService
        
        fetchRecentSnippets()
    }
    
    // MARK: - Methods
    
    internal func closeView() {
        NSApplication.shared.keyWindow?.close()
    }
    
    internal func fetchRecentSnippets() {
        userDefaultsService.fetchRecentSnippets()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.recentSnippets = $0
            }
            .store(in: &cancellables)
    }
    
}
