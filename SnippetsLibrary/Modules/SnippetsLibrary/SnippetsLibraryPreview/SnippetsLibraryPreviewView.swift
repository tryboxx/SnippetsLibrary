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
    @Binding internal var appAlert: AppAlert?
    
    private(set) var onTap: (_ snippet: Snippet) -> Void
    
    // MARK: - Views
    
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
                .makeVisible(
                    selectedSnippetId == nil,
                    removed: true
                )
            
            Text("Tap the snippet on the left to preview")
                .font(.system(size: 17.0))
                .foregroundColor(
                    Color.primary
                        .opacity(Layout.mediumOpacity)
                )
                .makeVisible(
                    selectedSnippetId == nil,
                    removed: true
                )
            
            SnippetFileCardView(
                viewModel: SnippetFileCardViewModel(
                    snippet: snippets.first(where: { $0.id == selectedSnippetId }),
                    state: .preview,
                    activeSheet: $activeSheet,
                    appAlert: $appAlert
                )
            )
            .padding()
            .onTapGesture {
                guard let snippet = snippets.first(where: { $0.id == selectedSnippetId }) else { return }
                activeSheet = .snippetDetails(snippet, .edit)
                onTap(snippet)
            }
            .makeVisible(
                selectedSnippetId != nil,
                removed: true
            )

            Spacer()
        }
        .frame(minWidth: Layout.defaultWindowSize.width * 0.65)
    }
    
}
