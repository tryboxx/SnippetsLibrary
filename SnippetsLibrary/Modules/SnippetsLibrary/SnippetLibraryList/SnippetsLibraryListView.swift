//
//  SnippetsLibraryListView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import SwiftUI

struct SnippetsLibraryListView: View {
    
    private enum Constants {
        static let minWidth: CGFloat = Layout.defaultWindowSize.width * 0.35
    }
    
    // MARK: - Stored Properties
    
    @Binding internal var snippets: [Snippet]
    @Binding internal var selectedSnippetId: SnippetId?
    
    @State private var searchedText = ""
    @State var shouldShowRemoveAlert = false
    
    private(set) var onReload: () -> Void
    private(set) var onRemove: (_ snippetId: SnippetId?) -> Void
    
    // MARK: - Computed Properties
    
    private var snippetGroups: [[Snippet]] {
        return [
            snippets.filter({ $0.type == .snippets }).filter { matchingSnippet($0) },
            snippets.filter({ $0.type == .extending }).filter { matchingSnippet($0) }
        ]
    }
    
    private var hasAnyResults: Bool {
        (snippetGroups.first?.isEmpty == true) && (snippetGroups.last?.isEmpty == true)
    }
    
    // MARK: - Views
    
    var body: some View {
        VStack {
            HStack {
                SearchBar {
                    searchedText = $0
                }
                
                Button {
                    onReload()
                } label: {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(Color.primary.opacity(Layout.mediumOpacity))
                }
                .buttonStyle(PlainButtonStyle())
                .help("Pull all changes from remote.")
            }
            .padding(.top, Layout.largePadding)
            .padding(.horizontal)
            
            List(selection: $selectedSnippetId) {
                ForEach(
                    snippetGroups,
                    id: \.self
                ) {
                    SnippetsLibraryListSectionView(
                        snippets: $0,
                        shouldShowRemoveAlert: $shouldShowRemoveAlert
                    )
                    .makeVisible(
                        !$0.isEmpty,
                        removed: true
                    )
                }
            }
            .overlay(
                EmptySnippetsListView(isListEmpty: .constant(snippets.isEmpty || hasAnyResults ))
            )
        }
        .frame(minWidth: Constants.minWidth)
        .background(
            VisualEffectView(
                material: .menu,
                blendingMode: .behindWindow
            )
        )
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: $shouldShowRemoveAlert) {
            Alert(
                title: Text("Confirm removing"),
                message: Text("You sure want to remove this snippet?"),
                primaryButton:
                    .destructive(
                        Text("Yes, remove"),
                        action: { onRemove(selectedSnippetId) }
                    ),
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: - Methods
    
    private func matchingSnippet(_ snippet: Snippet) -> Bool {
        snippet.title.lowercased().contains(searchedText.lowercased()) ||
            snippet.summary.lowercased().contains(searchedText.lowercased()) ||
            searchedText.isEmpty
    }
    
}

struct SnippetsLibraryListView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsLibraryListView(snippets: .constant([]), selectedSnippetId: .constant(nil), onReload: {}, onRemove: { _ in })
    }
}
