//
//  SnippetsLibraryListViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 01/10/2021.
//

import SwiftUI

final class SnippetsLibraryListViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    @Binding internal var snippets: [Snippet]
    @Binding internal var selectedSnippetId: SnippetId?
    
    @Published internal var searchedText = ""
    @Published internal var shouldShowRemoveAlert = false
    @Published internal var shouldShowFilterView = false
    @Published internal var selectedCategory: SnippetCategory? = nil
    
    private(set) var onReload: () -> Void
    private(set) var onRemove: (_ snippetId: SnippetId?) -> Void
    
    // MARK: - Computed Properties
    
    internal var snippetGroups: [[Snippet]] {
        return [
            snippets.filter({ $0.type == .snippets }).filter({ matchingSnippet($0) }).filter({ $0.category == selectedCategory || selectedCategory == nil }),
            snippets.filter({ $0.type == .extending }).filter { matchingSnippet($0) }
        ]
    }
    
    internal var hasAnyResults: Bool {
        (snippetGroups.first?.isEmpty == true) && (snippetGroups.last?.isEmpty == true)
    }
    
    // MARK: - Initialization
    
    init(
        snippets: Binding<[Snippet]>,
        selectedSnippetId: Binding<SnippetId?>,
        onReload: @escaping () -> Void,
        onRemove: @escaping (_ snippetId: SnippetId?) -> Void
    ) {
        self._snippets = snippets
        self._selectedSnippetId = selectedSnippetId
        self.onReload = onReload
        self.onRemove = onRemove
    }
    
    // MARK: - Methods
    
    private func matchingSnippet(_ snippet: Snippet) -> Bool {
        snippet.title.lowercased().contains(searchedText.lowercased()) ||
            snippet.summary.lowercased().contains(searchedText.lowercased()) ||
            searchedText.isEmpty
    }
    
}
