//
//  Provider.swift
//  SnippetsLibraryWidgetExtension
//
//  Created by Krzysztof Łowiec on 03/10/2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    private enum Constants {
        static let refreshInterval = 15
    }
    
    // MARK: - Computed Properties
    
    private var entries: [Entry] {
        var widgetEntries: [WidgetEntry] = []
        let userDefaultsService: UserDefaultsService = UserDefaultsServiceImpl()
        let snippets = userDefaultsService.fetchRecentSnippetsFromAppGroup()
        
        for snippet in snippets {
            widgetEntries.append(
                WidgetEntry(
                    snippet: snippet,
                    snippets: snippets
                )
            )
        }
        
        return widgetEntries
    }
    
    private var defaultWidgetEntry: WidgetEntry {
        WidgetEntry(
            snippet: entries.first?.snippet ?? Snippet(mockedForSkeleton: true),
            snippets: entries.first?.snippets ?? [
                Snippet(mockedForSkeleton: true),
                Snippet(mockedForSkeleton: true),
                Snippet(mockedForSkeleton: true)
            ]
        )
    }
    
    // MARK: - Methods
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (WidgetEntry) -> Void
    ) {
        completion(defaultWidgetEntry)
    }
    
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<WidgetEntry>) -> Void
    ) {
        var entries = entries
        
        let currentDate = Date()
        for index in .zero ..< entries.count {
            entries[index].date = Calendar.current.date(
                byAdding: .second,
                value: index * Constants.refreshInterval,
                to: currentDate
            )!
        }
        
        let timeline = Timeline(
            entries: entries,
            policy: .atEnd
        )
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> WidgetEntry {
        defaultWidgetEntry
    }
    
}
