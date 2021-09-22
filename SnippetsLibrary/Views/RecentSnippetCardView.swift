//
//  RecentSnippetCardView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

struct RecentSnippetCardView: View {
    
    private enum Constants {
        static let imageHeight: CGFloat = 38.0
        static let spacerHeight: CGFloat = 16.0
        static let cornerRadius: CGFloat = 6.0
        static let lineLimit = 1
        static let tapGestureCount = 2
    }
    
    // MARK: - Stored Properties
    
    let snippet: Snippet
    let tag: Int
    
    @Binding internal var selectedFileIndex: Int?
    
    private(set) var onTap: () -> Void
    
    // MARK: - Views
    
    var body: some View {
        Button {
            selectedFileIndex = tag
        } label: {
            HStack(spacing: .zero) {
                Image("icSnippetFileWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: Constants.imageHeight)
                
                VStack(
                    alignment: .leading,
                    spacing: Layout.smallPadding / 4
                ) {
                    Text(snippet.title)
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
        .buttonStyle(PlainButtonStyle())
        .tag(tag)
        .padding(.horizontal, Layout.smallPadding)
        .padding(.vertical, Layout.smallPadding / 2)
        .background(selectedFileIndex == tag ? Color("accent") : nil)
        .cornerRadius(Constants.cornerRadius)
        .simultaneousGesture(
            TapGesture(count: Constants.tapGestureCount)
                .onEnded(onTap)
        )
    }
    
}

struct RecentSnippetCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecentSnippetCardView(snippet: Snippet(), tag: 0, selectedFileIndex: .constant(nil)) {}
    }
}
