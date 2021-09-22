//
//  UserActivityLogType.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 17/09/2021.
//

import Foundation

enum UserActivityLogType {
    case userSavedSnippet(_ snippetId: String)
    case userUpdatedSnippet(_ snippetId: String)
    case userRemovedSnippet(_ snippetId: String)
    
    var title: String {
        switch self {
        case let .userSavedSnippet(snippetId):
            return "User saved snippet with id: \(snippetId)"
        case let .userUpdatedSnippet(snippetId):
            return "User updated snippet with id: \(snippetId)"
        case let .userRemovedSnippet(snippetId):
            return "User removed snippet with id: \(snippetId)"
        }
    }
    
    var level: UserActivityLevel {
        switch self {
        case .userSavedSnippet: return .low
        case .userUpdatedSnippet: return .medium
        case .userRemovedSnippet: return .high
        }
    }
}
