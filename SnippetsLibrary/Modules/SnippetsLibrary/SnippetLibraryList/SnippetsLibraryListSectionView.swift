//
//  SnippetsLibraryListSectionView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 21/09/2021.
//

import SwiftUI

struct SnippetsLibraryListSectionView: View {
    
    private enum Constants {
        static let defaultSectionName = "Section"
    }
    
    // MARK: - Stored Properties
    
    private(set) var snippets: [Snippet]
    @Binding internal var shouldShowRemoveAlert: Bool
    
    // MARK: - Views
    
    var body: some View {
        Section(header: Text(snippets.first?.type.title ?? Constants.defaultSectionName)) {
            ForEach(snippets, id: \.id) {
                SnippetListItemView(snippet: $0)
                    .contextMenu {
                        Button("Delete") {
                            shouldShowRemoveAlert.toggle()
                        }
                    }
            }
        }
        .tag(snippets.first?.type.rawValue ?? .zero)
    }
    
}

struct SnippetsLibraryListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsLibraryListSectionView(snippets: [], shouldShowRemoveAlert: .constant(false))
    }
}
