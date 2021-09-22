//
//  SnippetDetailsViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 11/09/2021.
//

import SwiftUI
import Combine

final class SnippetDetailsViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    @Published internal var snippet: Snippet
    @Binding internal var activeAppView: ActiveAppView?

    internal let type: SnippetDetailsViewType
    private var lastSavedSnippet: Snippet? = nil
    
    @Published internal var platformSelectionIndex: Int = 0
    internal var platforms = SnippetPlatform.allCases
    
    @Published internal var availabilitySelectionIndex: Int = 0
    internal var availabilities = SnippetAvailability.allCases
    
    @Published private(set) var shouldDismissView = false
    
    private let snippetsParserService: SnippetsParserService
    private let databaseService: DatabaseService
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    internal var hasChanges: Bool {
        lastSavedSnippet != snippet
    }
    
    // MARK: - Initialization
    
    init(
        snippet: Snippet,
        type: SnippetDetailsViewType,
        activeAppView: Binding<ActiveAppView?>,
        snippetsParserService: SnippetsParserService = DIContainer.snippetsParserService,
        databaseService: DatabaseService = DIContainer.databaseService
    ) {
        self.snippet = snippet
        self.type = type
        self._activeAppView = activeAppView
        self.snippetsParserService = snippetsParserService
        self.databaseService = databaseService
        
        setup()
    }
    
    // MARK: - Methods
    
    internal func performChanges() {
        guard hasChanges else { return }
        
        if type == .create {
            createSnippet()
        } else {
            updateSnippet()
        }
    }
    
    private func createSnippet() {
        snippetsParserService.createSnippet(snippet)
            .sink { completion in
                switch completion {
                case .finished: return
                case let .failure(error):
                    debugPrint("Error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] in
                self?.saveSnippetsInDatabase($0)
            }
            .store(in: &cancellables)
    }
    
    private func updateSnippet() {
        databaseService.updateSnippet(snippet)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self?.shouldDismissView.toggle()
                    }
                case let .failure(error):
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func saveSnippetsInDatabase(_ snippet: SnippetPlist) {
        databaseService.saveSnippet(snippet)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self?.shouldDismissView.toggle()
                    }
                case let .failure(error):
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func setup() {
        lastSavedSnippet = snippet
        platformSelectionIndex = SnippetPlatform.allCases.firstIndex(of: snippet.platform) ?? 0
        availabilitySelectionIndex = SnippetAvailability.allCases.firstIndex(of: snippet.availability) ?? 0
    }
    
}
