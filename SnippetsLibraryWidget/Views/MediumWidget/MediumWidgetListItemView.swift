//
//  MediumWidgetListItemView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 03/10/2021.
//

import SwiftUI

struct MediumWidgetListItemView: View {
    
    private enum Constants {
        static let imageHeight: CGFloat = 28.0
        static let lineLimit = 2
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
            
            Text("\(snippet.title)")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color.primary)
                .lineLimit(Constants.lineLimit)
                .padding(.leading, Layout.smallPadding)
            
            Spacer()
        }
    }
    
}

struct MediumWidgetListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidgetListItemView(snippet: Snippet())
    }
}
