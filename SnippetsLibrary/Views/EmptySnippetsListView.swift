//
//  EmptySnippetsListView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import SwiftUI

struct EmptySnippetsListView: View {
    
    // MARK: - Stored Properties
    
    @Binding private(set) var isListEmpty: Bool
    
    // MARK: - Views
    
    var body: some View {
        VStack(spacing: Layout.smallPadding) {
            Image(systemName: "cloud")
                .font(.system(size: 24, weight: .light))
                .foregroundColor(
                    Color.primary
                        .opacity(Layout.mediumOpacity)
                )
            
            Text("No code snippets found \nin a database")
                .foregroundColor(
                    Color.primary
                        .opacity(Layout.mediumOpacity)
                )
                .multilineTextAlignment(.center)
        }
        .offset(y: -Layout.largePadding)
        .makeVisible(
            isListEmpty,
            removed: true
        )
    }
    
}

struct EmptySnippetsListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySnippetsListView(isListEmpty: .constant(true))
    }
}
