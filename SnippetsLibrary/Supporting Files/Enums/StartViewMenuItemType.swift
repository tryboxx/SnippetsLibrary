//
//  StartViewMenuItemType.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 13/09/2021.
//

import Foundation

enum StartViewMenuItemType {
    case create
    case importSnippet
    case open
    
    var systemImageName: String {
        switch self {
        case .create: return "plus.square"
        case .importSnippet: return "square.and.arrow.down"
        case .open: return "folder"
        }
    }
    
    var imageFontSize: CGFloat {
        switch self {
        case .create: return 30.0
        case .importSnippet: return 31.0
        case .open: return 25.0
        }
    }
    
    var title: String {
        switch self {
        case .create: return "Create a new snippet file"
        case .importSnippet: return "Import an existing code snippet"
        case .open: return "Open snippets library"
        }
    }
    
    var subtitle: String {
        switch self {
        case .create: return "Create and upload the own code snippets."
        case .importSnippet: return "Import local code snippets into the Snippets Library."
        case .open: return "Open and browse an existing Snippets Library."
        }
    }
    
    var leadingPadding: CGFloat {
        switch self {
        case .importSnippet: return 1
        case .open: return -1
        default: return 0
        }
    }
}
