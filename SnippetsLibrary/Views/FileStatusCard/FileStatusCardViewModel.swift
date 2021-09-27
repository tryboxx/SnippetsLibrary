//
//  FileStatusCardViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 27/09/2021.
//

import Foundation

final class FileStatusCardViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    private(set) var snippet: Snippet
    private(set) var type: FileStatusCardType
    
    // MARK: - Initialization
    
    init(
        snippet: Snippet?,
        type: FileStatusCardType = .normal
    ) {
        self.snippet = snippet ?? Snippet()
        self.type = type
    }
    
    // MARK: - Methods
    
    internal func sendOpenSnippetNotification() {
        NotificationCenter.default.post(
            name: NSNotification.statusBarSnippetTapped,
            object: nil,
            userInfo: ["snippetId": snippet.id]
        )
    }
    
}
