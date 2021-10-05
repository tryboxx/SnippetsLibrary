//
//  MediumWidgetView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 03/10/2021.
//

import SwiftUI

struct MediumWidgetView: View {
    
    private enum Constants {
        static let imageHeight: CGFloat = 64.0
        static let maxSnippetsCount = 5
    }
    
    // MARK: - Stored Properties
    
    let snippets: [Snippet]
    
    // MARK: - Views
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: .zero) {
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(Color("widgetBackground"))
                        .frame(width: geometry.size.width / 2)
                }
                
                HStack {
                    SmallWidgetView(snippet: snippets.first ?? Snippet())
                        .frame(width: (geometry.size.width / 2) - Layout.smallPadding)
                    
                    VStack(alignment: .leading) {
                        ForEach(snippets.prefix(Constants.maxSnippetsCount).filter({ $0 != snippets.first }), id: \.self) { snippet in
                            Link(destination: URL(string: "widget://\(snippet.id)")!) {
                                MediumWidgetListItemView(snippet: snippet)
                            }
                        }
                        
                        Spacer()
                            .makeVisible(
                                snippets.count < Constants.maxSnippetsCount,
                                removed: true
                            )
                    }
                    .frame(
                        width: (geometry.size.width / 2) - Layout.smallPadding,
                        height: geometry.size.height - Layout.largePadding
                    )
                }
            }
        }
    }
    
}

struct MediumWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidgetView(snippets: [])
    }
}
