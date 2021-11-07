//
//  SnippetsLibraryView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import SwiftUI
import PopupView

struct SnippetsLibraryView: View {
    
    // MARK: - Stored Properties
    
    @ObservedObject private(set) var viewModel: SnippetsLibraryViewModel
    
    @Binding internal var activeSheet: AppSheet?
    @State private var appAlert: AppAlert? = nil
    @State private var shouldShowSnippetManual = false
    
    // MARK: - Views
    
    var body: some View {
        ZStack {
            HSplitView {
                SnippetsLibraryListView(
                    viewModel: SnippetsLibraryListViewModel(
                        snippets: $viewModel.snippets,
                        selectedSnippetId: $viewModel.selectedSnippetId
                    ) {
                        viewModel.fetchSnippets()
                    } onRemove: {
                        viewModel.onRemove($0)
                    }
                )
                
                SnippetsLibraryPreviewView(
                    snippets: $viewModel.snippets,
                    selectedSnippetId: $viewModel.selectedSnippetId,
                    activeSheet: $activeSheet,
                    appAlert: $appAlert
                ) {
                    viewModel.saveSnippetToRecentSnippets($0)
                }
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
        .onChange(of: viewModel.hasConnection) {
            viewModel.onChangeConnectionState(hasConnection: $0)
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
        .alert(item: $appAlert) {
            switch $0 {
            case .snippetDownload:
                return Alert(
                    title: Text("Unexpected error"),
                    message: Text("Unable to download the snippet. Please try again later."),
                    dismissButton: .cancel()
                )
            }
        }
        .makeDisplayed(
            with: $viewModel.shouldShowErrorAlert,
            imageName: "network",
            title: "Network error",
            subtitle: "Requested operation couldn't be completed",
            state: .failure
        )
        .popup(
            isPresented: $shouldShowSnippetManual,
            type: .floater(verticalPadding: Layout.defaultWindowSize.height),
            position: .bottom,
            animation: .easeInOut,
            closeOnTapOutside: true,
            backgroundColor: Color.black.opacity(Layout.mediumOpacity)
        ) {
            viewModel.markSnippetManualAsReaded()
        } view: {
            SnippetCreationManualView()
        }
        .onAppear {
            showSnippetManualIfNeeded()
        }
    }
    
    // MARK: - Methods
    
    private func showSnippetManualIfNeeded() {
        let userDefaultsService = DIContainer.userDefaultsService
        shouldShowSnippetManual = userDefaultsService.shouldShowSnippetManual()
    }

}

struct SnippetsLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsLibraryView(viewModel: SnippetsLibraryViewModel(hasConnection: .constant(true)), activeSheet: .constant(nil))
    }
}
