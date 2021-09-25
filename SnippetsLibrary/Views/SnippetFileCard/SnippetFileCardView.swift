//
//  SnippetFileCardView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI
import Sourceful

struct SnippetFileCardView: View {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 4.0
        static let codeEditorHorizontalPadding: CGFloat = 1.0
        static let codeEditorVerticlaPadding: CGFloat = 0.5
        static let codeEditorHeight: CGFloat = Layout.defaultWindowSize.height - (Layout.largePadding * 2)
        static let strokeWidth: CGFloat = 1.0
        static let minimalOpacity = 0.0001
    }
    
    // MARK: - Stored Properties
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject private(set) var viewModel: SnippetFileCardViewModel
    
    // MARK: - Views
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.titleText.isEmpty ? viewModel.snippet.title : viewModel.titleText)
                .font(.headline)
            
            ZStack {
                SourceCodeTextEditor(
                    text: .constant(viewModel.snippet.content),
                    customization: SourceCodeTextEditor.Customization(
                        didChangeText: { _ in },
                        insertionPointColor: { colorScheme == .dark ? .white : .black },
                        lexerForSource: { _ in SwiftLexer() },
                        textViewDidBeginEditing: { _ in },
                        theme: { CustomCodeTheme(colorScheme: colorScheme) }
                    ),
                    shouldBecomeFirstResponder: false
                )
                .frame(
                    height: Constants.codeEditorHeight,
                    alignment: .leading
                )
                .padding(.horizontal, Constants.codeEditorHorizontalPadding)
                .padding(.vertical, Constants.codeEditorVerticlaPadding)
                .cornerRadius(Constants.cornerRadius)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(style: StrokeStyle(lineWidth: Constants.strokeWidth))
                        .foregroundColor(Color.black)
                )
                
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundColor(
                        Color.black
                            .opacity(Constants.minimalOpacity)
                    )
                    .makeVisible(viewModel.state == .preview)
            }
            
            HStack {
                Button(
                    "Delete",
                    action: { viewModel.onDelete?() }
                )
                
                Spacer()
            }
            .padding(.vertical)
            .makeVisible(
                viewModel.state == .edit,
                removed: true
            )
        }
    }
    
}

struct SnippetFileCardView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetFileCardView(viewModel: SnippetFileCardViewModel(snippet: Snippet(), state: .preview))
    }
}
