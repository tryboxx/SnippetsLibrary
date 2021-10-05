//
//  SnippetsLibraryWidgetView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 03/10/2021.
//

import WidgetKit
import SwiftUI

struct SnippetsLibraryWidgetView: View {
    
    // MARK: - Stored Properties
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    private(set) var entry: Provider.Entry
    
    // MARK: - Views
    
    var body: some View {
        switch family {
        case .systemMedium:
            MediumWidgetView(snippets: entry.snippets)
        default:
            SmallWidgetView(snippet: entry.snippet)
        }
    }
    
}

struct SnippetsLibraryWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsLibraryWidgetView(entry: .init(snippet: Snippet(), snippets: []))
    }
}
