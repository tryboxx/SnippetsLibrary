//
//  StatusView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 27/09/2021.
//

import SwiftUI

struct StatusView: View {
    
    private enum Constants {
        static let emptySnippetsViewSize = CGSize(width: 230, height: 150)
        static let cornerRadius: CGFloat = 12.0
        static let strokeLineWidth: CGFloat = 1
        static let strokeDashSpacing: CGFloat = 10
        static let viewWidth: CGFloat = 230
        static let viewMinHeight: CGFloat = 80
        static let viewMaxHeight: CGFloat = 150
    }
    
    // MARK: - Stored Properties
    
    @StateObject var viewModel = StatusViewModel()
    
    // MARK: - Views
    
    var body: some View {
        VStack {
            VStack {
                Text("No recent snippets")
                    .font(.system(size: 17.0))
            }
            .frame(
                width: Constants.emptySnippetsViewSize.width,
                height: Constants.emptySnippetsViewSize.height
            )
            .overlay(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: Constants.strokeLineWidth,
                            dash: [Constants.strokeDashSpacing],
                            dashPhase: .zero
                        )
                    )
                    .foregroundColor(.primary)
            )
            .padding()
            .makeVisible(
                viewModel.snippets.isEmpty,
                removed: true
            )
            
            Group {
                FileStatusCard(
                    viewModel: FileStatusCardViewModel(
                        snippet: viewModel.snippets.first,
                        type: .large
                    )
                )
                
                HStack {
                    HStack {
                        FileStatusCard(
                            viewModel: FileStatusCardViewModel(
                                snippet: viewModel.snippets.last
                            )
                        )
                        
                        Spacer()
                    }
                    .makeVisible(
                        viewModel.snippets.count > 1,
                        removed: true
                    )
                    
                    FileStatusCard(
                        viewModel: FileStatusCardViewModel(
                            snippet: viewModel.snippets.randomElement()
                        )
                    )
                    .makeVisible(
                        viewModel.snippets.count > 2,
                        removed: true
                    )
                }
            }
            .makeVisible(
                !viewModel.snippets.isEmpty,
                removed: true
            )
            
            Spacer()
        }
        .accentColor(Color.accentColor)
        .frame(
            width: Constants.viewWidth,
            height: viewModel.snippets.count == 1 ? Constants.viewMinHeight : Constants.viewMaxHeight
        )
    }
    
}
