//
//  SnippetAvailability.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 13/09/2021.
//

import Foundation

enum SnippetAvailability: CaseIterable {
    case allScopes
    case implementation
    case expression
    case function
    case string
    case topLevel
    
    var title: String {
        switch self {
        case .allScopes: return "All Scopes"
        case .implementation: return "Class Implementation"
        case .expression: return "Code Expression"
        case .function: return "Function or Method"
        case .string: return "String or Comment"
        case .topLevel: return "Top Level"
        }
    }
    
    var string: String {
        switch self {
        case .allScopes: return "All"
        case .implementation: return "ClassImplementation"
        case .expression: return "CodeExpression"
        case .function: return "CodeBlock"
        case .string: return "StringOrComment"
        case .topLevel: return "TopLevel"
        }
    }
}
