//
//  AppSheet.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import SwiftUI

enum AppSheet: Identifiable {
    case snippetDetails(_ snippet: Snippet, _ type: SnippetDetailsViewType)
    
    var id: Int {
        switch self {
        case .snippetDetails:
            return 0
        }
    }
}
