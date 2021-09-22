//
//  File.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 13/09/2021.
//

import Foundation

enum SnippetPlatform: String, CaseIterable {
    case all
    case iphoneos
    case macos
    case tvos
    case watchos
    
    var title: String {
        switch self {
        case .all: return "All platforms"
        case .iphoneos: return "iOS"
        case .macos: return "macOS"
        case .tvos: return "tvOS"
        case .watchos: return "watchOS"
        }
    }
}
