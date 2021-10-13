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
        static let codeEditorVerticlaPadding: CGFloat = 0.0
        static let codeEditorHeight: CGFloat = Layout.defaultWindowSize.height - (Layout.largePadding * 4)
        static let strokeWidth: CGFloat = 1.0
        static let minimalOpacity = 0.0001
        static let bottomBarHeight: CGFloat = 20.0
        static let bottomBarCornerRadius: CGFloat = 2.0
    }
    
    // MARK: - Stored Properties
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject private(set) var viewModel: SnippetFileCardViewModel
    
    // MARK: - Views
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: .zero
        ) {
            HStack {
                Text(viewModel.titleText.isEmpty ? viewModel.snippet.title : viewModel.titleText)
                    .font(.headline)
                
                Spacer()
                
                Group {
                    Button {
                        viewModel.downloadSnippet()
                    } label: {
                        Image(systemName: "arrow.down.circle")
                            .font(.system(size: 15, weight: .light))
                            .opacity(Layout.largeOpacity)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .help("Download selected snippet")
                    
                    Button {
                        viewModel.openSnippetDetails()
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 15, weight: .light))
                            .opacity(Layout.largeOpacity)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .help("Show snippet details")
                }
            }
            
            HStack {
                ForEach(
                    viewModel.snippet.tags ?? [],
                    id: \.self
                ) {
                    Text($0)
                        .font(.footnote)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, Layout.smallPadding / 2)
                        .padding(.vertical, Layout.smallPadding / 4)
                        .background(
                            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                .foregroundColor(
                                    Color.accentColor
                                        .opacity(Layout.mediumOpacity)
                                )
                        )
                }
            }
            .padding(.vertical, Layout.smallPadding)
            
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
                    minHeight: Constants.codeEditorHeight,
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
                Text("SwiftUI")
                    .font(.footnote)
                    .opacity(Layout.mediumOpacity)
                    .padding(.leading, Layout.smallPadding)
                
                Divider()
                
                Spacer()
                
                Divider()
                
                Text("\(viewModel.linesCount()) lines")
                    .font(.footnote)
                    .opacity(Layout.mediumOpacity)
                    .padding(.trailing, Layout.smallPadding)
            }
            .frame(height: Constants.bottomBarHeight)
            .background(
                RoundedRectangle(cornerRadius: Constants.bottomBarCornerRadius)
                    .foregroundColor(Color("darkGrey"))
            )
            .padding(.vertical, Layout.smallPadding)
        }
    }
    
}

struct SnippetFileCardView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetFileCardView(viewModel: SnippetFileCardViewModel(snippet: Snippet(), state: .preview, activeSheet: .constant(nil), appAlert: .constant(nil)))
    }
}
