//
//  ActiveAppView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import Foundation

enum ActiveAppView: Identifiable, Equatable {
    case create
    case importSnippet
    case snippetsLibrary(_ directWithSnippetId: SnippetId?)
    
    var id: Int {
        switch self {
        case .create: return 0
        case .importSnippet: return 1
        case .snippetsLibrary: return 2
        }
    }
}
