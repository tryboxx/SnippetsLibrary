//
//  SnippetsLibraryPreviewView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import SwiftUI

struct SnippetsLibraryPreviewView: View {
    
    // MARK: - Stored Properties
    
    @Binding internal var snippets: [Snippet]
    @Binding internal var selectedSnippetId: SnippetId?
    @Binding internal var activeSheet: AppSheet?
    
    private(set) var onTap: (_ snippet: Snippet) -> Void
    
    // MARK: - Views
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                
                Text("Tap the snippet on the left to preview")
                    .font(.system(size: 17.0))
                    .foregroundColor(
                        Color.primary
                            .opacity(Layout.mediumOpacity)
                    )
            }
            .makeVisible(
                selectedSnippetId == nil,
                removed: true
            )
            
            List(snippets.filter({ $0.id == selectedSnippetId })) {
                SnippetFileCardView(
                    viewModel: SnippetFileCardViewModel(
                        snippet: $0,
                        state: .preview
                    )
                )
                .onTapGesture {
                    guard let snippet = snippets.first(where: { $0.id == selectedSnippetId }) else { return }
                    activeSheet = .snippetDetails(snippet, .edit)
                    onTap(snippet)
                }
            }
            .makeVisible(selectedSnippetId != nil)
            
            Spacer()
        }
        .frame(minWidth: Layout.defaultWindowSize.width * 0.65)
    }
    
}
