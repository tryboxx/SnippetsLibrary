//
//  SmallWidgetView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 02/10/2021.
//

import SwiftUI

struct SmallWidgetView: View {
    
    private enum Constants {
        static let imageHeight: CGFloat = 64.0
        static let shadowOpacity = 0.16
        static let shadowRadius: CGFloat = 6.0
        static let shadowYOffset: CGFloat = 3.0
    }
    
    // MARK: - Stored Properties
    
    let snippet: Snippet
    
    // MARK: - Views
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: .zero
        ) {
            Image("icSnippetFileBlank")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: Constants.imageHeight)
                .shadow(
                    color: Color.black
                        .opacity(Constants.shadowOpacity),
                    radius: Constants.shadowRadius,
                    x: .zero,
                    y: Constants.shadowYOffset
                )
            
            Spacer()
            
            Text(snippet.title)
                .font(.headline)
            
            Text(snippet.summary)
                .font(.footnote)
                .foregroundColor(
                    Color.primary
                        .opacity(Layout.mediumOpacity)
                )
        }
        .padding()
        .widgetURL(URL(string: "widget://\(snippet.id)")!)
    }
    
}

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView(snippet: Snippet())
    }
}
