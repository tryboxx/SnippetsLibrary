//
//  SnippetsLibraryView+Equatable.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import Foundation

extension SnippetsLibraryView: Equatable {
    
    static func == (lhs: SnippetsLibraryView, rhs: SnippetsLibraryView) -> Bool {
        return lhs.viewModel.snippets != rhs.viewModel.snippets
    }
    
}
