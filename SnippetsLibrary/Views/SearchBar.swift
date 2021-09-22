//
//  SearchBar.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import SwiftUI

struct SearchBar: View {
    
    private enum Constants {
        static let animationDuration: Double = 0.2
    }
    
    // MARK: - Stored Properties
    
    @State private var searchedText = ""
    @State private var isEditing = false
    
    private(set) var onChange: (String) -> Void
    
    // MARK: - Views

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13.0))
                .foregroundColor(
                    Color.primary
                        .opacity(Layout.mediumOpacity)
                )
            
            TextField(
                "Search for snippets...",
                text: $searchedText
            ) { isEditing in
                onChange(searchedText)
                withAnimation {
                    self.isEditing = isEditing
                }
            } onCommit: {
                onChange(searchedText)
                isEditing = false
            }
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.vertical, Layout.smallPadding)
            .onChange(of: searchedText) { text in
                onChange(text)
            }
            
            Button {
                searchedText = ""
                isEditing = false
            } label: {
                Image(systemName: "multiply.circle.fill")
                    .foregroundColor(Color.gray)
                    .padding(.leading, Layout.smallPadding)
            }
            .buttonStyle(PlainButtonStyle())
            .makeVisible(isEditing)
            .animation(.easeIn(duration: Constants.animationDuration))
        }
    }
    
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar() { _ in }
    }
}
