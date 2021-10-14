//
//  SnippetFileCardViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

final class SnippetFileCardViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    private(set) var snippet: Snippet
    private(set) var state: SnippetFileCardViewState
    
    @Published internal var titleText = ""
    @Published internal var contentText = ""
    @Binding internal var appAlert: AppAlert?
    @Binding internal var activeSheet: AppSheet?
    
    private let snippetParserService: SnippetsParserService
    
    private(set) var onDelete: (() -> Void)? = nil
    
    // MARK: - Initialization
    
    init(
        snippet: Snippet?,
        state: SnippetFileCardViewState,
        activeSheet: Binding<AppSheet?>,
        appAlert: Binding<AppAlert?>,
        snippetParserService: SnippetsParserService = DIContainer.snippetsParserService,
        onDelete: (() -> Void)? = nil
    ) {
        self.snippet = snippet ?? Snippet()
        self.state = state
        _activeSheet = activeSheet
        _appAlert = appAlert
        self.snippetParserService = snippetParserService
        self.onDelete = onDelete
        
        setup()
    }
    
    // MARK: - Methods
    
    internal func downloadSnippet() {
        snippetParserService.writeToPath(
            type: .download,
            snippets: [snippet]
        ) {
            self.appAlert = .snippetDownload
        }
    }
    
    internal func linesCount() -> Int {
        return contentText.numberOfLines()
    }
    
    internal func openSnippetDetails() {
        activeSheet = .snippetDetails(snippet, .edit)
    }
    
    private func setup() {
        titleText = snippet.title
        contentText = snippet.content
        snippet.tags = snippet.tags?.isEmpty == true ? ["SwiftUI"] : []
    }
    
}
