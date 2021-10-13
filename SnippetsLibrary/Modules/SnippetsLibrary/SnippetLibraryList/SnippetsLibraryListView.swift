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
    
    @ObservedObject private(set) var viewModel: SnippetsLibraryListViewModel
    
    // MARK: - Views
    
    var body: some View {
        VStack {
            HStack {
                SearchBar {
                    viewModel.searchedText = $0
                }
                .padding(.leading)
                
                Button {
                    withAnimation {
                        viewModel.shouldShowFilterView.toggle()
                    }
                } label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(
                            Color.primary
                                .opacity(Layout.mediumOpacity)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .help("Choose the filters")
                
                Button {
                    viewModel.onReload()
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(
                            Color.primary
                                .opacity(Layout.mediumOpacity)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .help("Pull all changes from remote")
                .padding(.trailing, Layout.smallPadding)
            }
            .padding(.top, Layout.largePadding)
            
            SnippetsLibraryListFilterView(selectedCategory: $viewModel.selectedCategory)
                .makeVisible(
                    viewModel.shouldShowFilterView,
                    removed: true
                )
                .animation(.default)
            
            List(selection: $viewModel.selectedSnippetId) {
                ForEach(
                    viewModel.snippetGroups,
                    id: \.self
                ) {
                    SnippetsLibraryListSectionView(
                        snippets: $0,
                        shouldShowRemoveAlert: $viewModel.shouldShowRemoveAlert
                    )
                    .makeVisible(
                        !$0.isEmpty,
                        removed: true
                    )
                }
            }
            .overlay(
                EmptySnippetsListView(isListEmpty: .constant(viewModel.snippets.isEmpty || viewModel.hasAnyResults ))
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
        .alert(isPresented: $viewModel.shouldShowRemoveAlert) {
            Alert(
                title: Text("Confirm removing"),
                message: Text("You sure want to remove this snippet?"),
                primaryButton:
                    .destructive(
                        Text("Yes, remove"),
                        action: { viewModel.onRemove(viewModel.selectedSnippetId) }
                    ),
                secondaryButton: .cancel()
            )
        }
    }
    
}

struct SnippetsLibraryListView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsLibraryListView(viewModel: SnippetsLibraryListViewModel(snippets: .constant([]), selectedSnippetId: .constant(nil), onReload: {}, onRemove: { _ in }))
    }
}
