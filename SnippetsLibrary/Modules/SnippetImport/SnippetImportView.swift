//
//  SnippetImportView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/09/2021.
//

import SwiftUI

struct SnippetImportView: View {
    
    private enum Constants {
        static let dropCellSize = CGSize(width: 250, height: 170)
        static let cornerRadius: CGFloat = 12.0
        static let lineWidth: CGFloat = 1
        static let dashCount: CGFloat = 10
    }
    
    // MARK: - Stored Properties
    
    @ObservedObject private(set) var viewModel: SnippetImportViewModel
    
    // MARK: - Views
    
    var body: some View {
        ZStack {
            VisualEffectView(
                material: .windowBackground,
                blendingMode: .behindWindow
            )
            
            ZStack {
                VStack {
                    SnippetDropCellView(snippet: viewModel.snippet)
                        .frame(
                            width: Constants.dropCellSize.width,
                            height: Constants.dropCellSize.height
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                .stroke(
                                    style: StrokeStyle(
                                        lineWidth: Constants.lineWidth,
                                        dash: [Constants.dashCount]
                                    )
                                )
                                .foregroundColor(Color.primary)
                        )
                        .padding([.horizontal, .bottom])
                }
            }
            .onDrop(
                of: [.fileURL],
                delegate: viewModel.self
            )
        }
    }
    
}

struct SnippetImportView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetImportView(viewModel: SnippetImportViewModel(activeAppView: .constant(nil)))
    }
}
