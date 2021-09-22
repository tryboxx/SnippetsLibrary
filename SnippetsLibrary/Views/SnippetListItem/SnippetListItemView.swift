//
//  SnippetListItemView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import SwiftUI

struct SnippetListItemView: View {
    
    private enum Constants {
        static let imageHeight: CGFloat = 38.0
        static let lineLimit = 1
        static let spacing = Layout.smallPadding / 4
    }
    
    // MARK: - Stored Properties
    
    let snippet: Snippet
    
    // MARK: - Views

    var body: some View {
        HStack(spacing: .zero) {
            Image("icSnippetFileWhite")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: Constants.imageHeight)
            
            VStack(
                alignment: .leading,
                spacing: Constants.spacing
            ) {
                Text("\(snippet.title)")
                    .font(.system(size: 13))
                    .foregroundColor(Color.primary)
                    .lineLimit(Constants.lineLimit)
                
                Text(snippet.summary)
                    .font(.system(size: 11))
                    .foregroundColor(
                        Color.primary
                            .opacity(Layout.mediumOpacity)
                    )
                    .lineLimit(Constants.lineLimit)
            }
            .padding(.leading, Layout.smallPadding)
            
            Spacer()
        }
    }
    
}

struct SnippetListItemView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetListItemView(snippet: Snippet())
    }
}
