//
//  SnippetFileCardViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI
import Combine

final class SnippetFileCardViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    private(set) var snippet: Snippet
    private(set) var state: SnippetFileCardViewState
    
    @Published internal var titleText = ""
    @Published internal var contentText = ""
    
    private(set) var onDelete: (() -> Void)? = nil
    
    // MARK: - Initialization
    
    init(
        snippet: Snippet,
        state: SnippetFileCardViewState,
        onDelete: (() -> Void)? = nil
    ) {
        self.snippet = snippet
        self.state = state
        self.onDelete = onDelete
        
        setup()
    }
    
    // MARK: Methods
    
    private func setup() {
        titleText = snippet.title
        contentText = snippet.content
    }
    
}
