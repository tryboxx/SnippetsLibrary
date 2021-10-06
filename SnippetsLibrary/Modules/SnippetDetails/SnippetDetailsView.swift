//
//  SnippetDetailsView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import SwiftUI
import Sourceful

struct SnippetDetailsView: View {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 4.0
        static let codeEditorHorizontalPadding: CGFloat = 1.0
        static let codeEditorVerticlaPadding: CGFloat = 0.5
        static let codeEditorHeight: CGFloat = Layout.defaultWindowSize.height - (Layout.largePadding * 2)
        static let strokeWidth: CGFloat = 1.0
        static let textWidth: CGFloat = 65.0
        static let lineTopPadding: CGFloat = 6.0
    }
    
    // MARK: - Stored Properties
    
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.presentationMode) var presentationMode
    
    @StateObject internal var viewModel: SnippetDetailsViewModel
    
    // MARK: - Views
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            TextField(
                "Snippet title",
                text: $viewModel.snippet.title
            )
            .modifier(TextFieldStyleModifier(type: viewModel.type))
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(Color.primary)
            
            TextField(
                "Snippet summary",
                text: $viewModel.snippet.summary
            )
            .modifier(TextFieldStyleModifier(type: viewModel.type))
            .font(.system(size: 11, weight: .regular))
            .foregroundColor(Color.primary)
            .padding(.top, Layout.smallPadding / 2)
            
            GeometryReader { geometry in
                SourceCodeTextEditor(
                    text: $viewModel.snippet.content,
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
                    width: geometry.frame(in: .global).width,
                    height: geometry.frame(in: .global).height
                )
            }
            .padding(.horizontal, Constants.codeEditorHorizontalPadding)
            .padding(.vertical, Constants.codeEditorVerticlaPadding)
            .cornerRadius(Constants.cornerRadius)
            .background(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(style: StrokeStyle(lineWidth: Constants.strokeWidth))
                    .foregroundColor(Color.black)
            )
            .padding(.vertical)
            
            HStack {
                Text("Platform")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.primary.opacity(Layout.mediumOpacity))
                    .frame(
                        width: Constants.textWidth,
                        alignment: .leading
                    )
                
                Picker("", selection: $viewModel.platformSelectionIndex) {
                    ForEach(
                        viewModel.platforms.indices,
                        id: \.self
                    ) { index in
                        Text(viewModel.platforms[index].title)
                    }
                }
                .frame(
                    width: Layout.defaultWindowSize.width / 4,
                    alignment: .leading
                )
                .onChange(of: viewModel.platformSelectionIndex) { index in
                    viewModel.snippet.platform = viewModel.platforms[index]
                }
            }
            
            HStack {
                Text("Completion")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.primary.opacity(Layout.mediumOpacity))
                    .frame(
                        width: Constants.textWidth,
                        alignment: .leading
                    )
                
                TextField(
                    "Completion",
                    text: $viewModel.snippet.completion
                )
                .modifier(TextFieldStyleModifier(type: viewModel.type))
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color.primary)
                .frame(
                    width: (Layout.defaultWindowSize.width / 4) - Layout.smallPadding,
                    alignment: .leading
                )
                .padding(.leading, Layout.smallPadding)
            }
            .padding(.top, Constants.lineTopPadding)
            
            HStack {
                Text("Availability")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.primary.opacity(Layout.mediumOpacity))
                    .frame(
                        width: Constants.textWidth,
                        alignment: .leading
                    )
                
                Picker("", selection: $viewModel.availabilitySelectionIndex) {
                    ForEach(
                        viewModel.availabilities.indices,
                        id: \.self
                    ) { index in
                        Text(viewModel.availabilities[index].title)
                    }
                }
                .frame(
                    width: Layout.defaultWindowSize.width / 4,
                    alignment: .leading
                )
                .onChange(of: viewModel.availabilitySelectionIndex) { index in
                    viewModel.snippet.availability = viewModel.availabilities[index]
                }
            }
            .padding(.top, Constants.lineTopPadding)
            
            HStack {
                Text("Author")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.primary.opacity(Layout.mediumOpacity))
                    .frame(
                        width: Constants.textWidth,
                        alignment: .leading
                    )
                if viewModel.type == .create {
                    TextField(
                        "Author",
                        text: $viewModel.snippet.author
                    )
                    .modifier(TextFieldStyleModifier(type: viewModel.type))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.primary)
                    .frame(
                        width: (Layout.defaultWindowSize.width / 4) - Layout.smallPadding,
                        alignment: .leading
                    )
                    .padding(.leading, Layout.smallPadding)
                } else {
                    Text(viewModel.snippet.author)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Color.primary)
                        .frame(
                            width: (Layout.defaultWindowSize.width / 4) - Layout.smallPadding,
                            alignment: .leading
                        )
                        .padding(.leading, Layout.smallPadding)
                }
            }
            .padding(.top, Constants.lineTopPadding)
            
            Spacer()
            
            HStack {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                
                Spacer()

                Button("Save") {
                    viewModel.performChanges()
                }
                .disabled(!viewModel.hasChanges)
            }
            .padding(.top, Layout.mediumPadding)
        }
        .padding()
        .frame(
            minWidth: Layout.defaultWindowSize.width * 0.6,
            minHeight: Layout.defaultWindowSize.height * 0.95
        )
        .onChange(of: viewModel.shouldDismissView) { _ in
            presentationMode.wrappedValue.dismiss()
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

struct SnippetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetDetailsView(viewModel: SnippetDetailsViewModel(snippet: Snippet(), type: .edit, activeAppView: .constant(nil)))
    }
}
