//
//  WidgetEntry.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 03/10/2021.
//

import WidgetKit

struct WidgetEntry: TimelineEntry {
    
    var date: Date = Date()
    let snippet: Snippet
    let snippets: [Snippet]
    
}
