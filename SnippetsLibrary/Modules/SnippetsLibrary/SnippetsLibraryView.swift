//
//  SnippetsLibraryView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import SwiftUI
import Combine

struct SnippetsLibraryView: View {
    
    // MARK: - Stored Properties
    
    @ObservedObject private(set) var viewModel: SnippetsLibraryViewModel
    
    @Binding internal var activeSheet: AppSheet?
    
    // MARK: - Views
    
    var body: some View {
        HSplitView {
            SnippetsLibraryListView(
                snippets: $viewModel.snippets,
                selectedSnippetId: $viewModel.selectedSnippetId
            ) {
                viewModel.fetchSnippets()
            } onRemove: {
                viewModel.onRemove($0)
            }
            
            SnippetsLibraryPreviewView(
                snippets: $viewModel.snippets,
                selectedSnippetId: $viewModel.selectedSnippetId,
                activeSheet: $activeSheet
            ) {
                viewModel.saveSnippetToRecentSnippets($0)
            }
        }
        .frame(
            minWidth: Layout.defaultWindowSize.width,
            maxWidth: .infinity,
            minHeight: Layout.defaultWindowSize.height,
            maxHeight: .infinity
        )
        .onChange(of: viewModel.snippets) { _ in
            viewModel.showSnippetPreview()
        }
        .sheet(item: $activeSheet) {
            switch $0 {
            case let .snippetDetails(snippet, type):
                SnippetDetailsView(
                    viewModel: SnippetDetailsViewModel(
                        snippet: snippet,
                        type: type,
                        activeAppView: .constant(nil)
                    )
                )
            case .snippetsUpload:
                SnippetsUploadView(viewModel: SnippetsUploadViewModel(snippets: viewModel.snippets))
            }
        }
        .makeDisplayed(
            with: $viewModel.shouldShowErrorAlert,
            imageName: "network",
            title: "Network error",
            subtitle: "Requested operation couldn't be completed",
            state: .failure
        )
    }

}

struct SnippetsLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsLibraryView(viewModel: SnippetsLibraryViewModel(), activeSheet: .constant(nil))
    }
}
