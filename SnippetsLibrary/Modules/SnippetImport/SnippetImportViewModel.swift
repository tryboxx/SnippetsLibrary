//
//  SnippetImportViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/09/2021.
//

import SwiftUI
import Combine

final class SnippetImportViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    @Published internal var snippet: Snippet?
    @Binding internal var activeAppView: ActiveAppView?
    
    @Published internal var shouldShowErrorAlert = false
    
    private let snippetsParserService: SnippetsParserService
    private let databaseService: DatabaseService
    private let crashlyticsService: CrashlyticsService
    
    internal var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(
        snippetsParserService: SnippetsParserService = DIContainer.snippetsParserService,
        databaseService: DatabaseService = DIContainer.databaseService,
        crashlyticsService: CrashlyticsService = DIContainer.crashlyticsService,
        activeAppView: Binding<ActiveAppView?>
    ) {
        self.snippetsParserService = snippetsParserService
        self._activeAppView = activeAppView
        self.databaseService = databaseService
        self.crashlyticsService = crashlyticsService
    }
    
    // MARK: - Methods
    
    internal func createSnippet(_ snippet: Snippet) {
        snippetsParserService.createSnippet(snippet)
            .sink { [weak self] completion in
                switch completion {
                case .finished: return
                case .failure:
                    self?.shouldShowErrorAlert.toggle()
                    self?.crashlyticsService.logNonFatalError(.unableToCreateSnippetFromDroppedFile)
                }
            } receiveValue: { [weak self] in
                self?.saveSnippetsInDatabase($0)
            }
            .store(in: &self.cancellables)
    }
    
    internal func saveSnippetsInDatabase(_ snippet: SnippetPlist) {
        databaseService.saveSnippet(snippet)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.activeAppView = .snippetsLibrary(snippet.id)
                case .failure:
                    self?.shouldShowErrorAlert.toggle()
                }
            }
            .store(in: &cancellables)
    }
    
}
