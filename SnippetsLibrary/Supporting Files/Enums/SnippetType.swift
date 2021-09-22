//
//  SnippetType.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 21/09/2021.
//

import Foundation

enum SnippetType: Int, CaseIterable {
    case snippets
    case extending
    
    var title: String {
        switch self {
        case .snippets: return "Snippets"
        case .extending: return "Extensions"
        }
    }
}
