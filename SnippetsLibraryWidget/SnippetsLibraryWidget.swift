//
//  SnippetsLibraryWidget.swift
//  SnippetsLibraryWidget
//
//  Created by Krzysztof Łowiec on 02/10/2021.
//

import WidgetKit
import SwiftUI

@main
struct SnippetsLibraryWidget: Widget {
    
    // MARK: - Stored Properties
    
    private let kind: String = "SnippetsLibraryWidget"
    
    // MARK: - Views

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) {
            SnippetsLibraryWidgetView(entry: $0)
        }
        .configurationDisplayName("Snippets Library Widget")
        .description("General statistics for the Snippet Library.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
    
}

struct SnippetsLibraryWidget_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsLibraryWidgetView(entry: WidgetEntry(date: Date(), snippet: Snippet(), snippets: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
