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
        static let spacing = Layout.smallPadding / 2
        static let smallSpacing = Layout.smallPadding / 4
        static let cornerRadius: CGFloat = 8.0
    }
    
    // MARK: - Stored Properties
    
    let snippet: Snippet
    
    // MARK: - Computed Properties
    
    private var shouldAnimate: Bool {
        snippet.content.isEmpty
    }
    
    // MARK: - Views

    var body: some View {
        HStack(spacing: .zero) {
            Image("icSnippetFileWhite")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: Constants.imageHeight)
                .makeSkeletonable(animating: shouldAnimate)
            
            VStack(
                alignment: .leading,
                spacing: Constants.smallSpacing
            ) {
                Text("\(snippet.title)")
                    .font(.system(size: 13))
                    .foregroundColor(Color.primary)
                    .lineLimit(Constants.lineLimit)
                    .makeSkeletonable(animating: shouldAnimate)
                
                Text(snippet.summary)
                    .font(.system(size: 11))
                    .foregroundColor(
                        Color.primary
                            .opacity(Layout.mediumOpacity)
                    )
                    .lineLimit(Constants.lineLimit)
                    .makeSkeletonable(animating: shouldAnimate)
            }
            .padding(.leading, Layout.smallPadding)
            
            Spacer()
        }
        .padding(
            .horizontal,
            shouldAnimate ? Constants.spacing : .zero
        )
        .padding(
            .vertical,
            shouldAnimate ? Constants.smallSpacing : .zero
        )
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .makeSkeletonable(
                    animating: shouldAnimate,
                    isBottomView: true
                )
                .makeVisible(
                    shouldAnimate,
                    removed: true
                )
        )
    }
    
}

struct SnippetListItemView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetListItemView(snippet: Snippet())
    }
}
