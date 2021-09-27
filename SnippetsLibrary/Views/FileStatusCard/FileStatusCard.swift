//
//  FileStatusCard.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 27/09/2021.
//

import SwiftUI

struct FileStatusCard: View {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10.0
        static let strokeWidth: CGFloat = 0.2
        static let mediumOpacity = 0.5
        static let tinyOpacity = 0.2
        static let imageLeadingPadding: CGFloat = 10.0
        static let imageRegularHeight: CGFloat = 38.0
        static let imageSmallHeight: CGFloat = 30.0
        static let lineLimit = 1
        static let smallPadding: CGFloat = 6.0
        static let shadowRadius: CGFloat = 4.0
        static let shadowPosition = CGPoint(x: 0, y: 2)
        static let windowSize = CGSize(width: 230, height: 65)
        static let smallWindowWidth: CGFloat = 110
    }
    
    // MARK: - Stored Properties
    
    @ObservedObject internal var viewModel: FileStatusCardViewModel
    
    // MARK: - Views
    
    var body: some View {
        Button {
            viewModel.sendOpenSnippetNotification()
        } label: {
            ZStack {
                VisualEffectView(
                    material: .menu,
                    blendingMode: .behindWindow
                )
                
                Rectangle()
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .stroke(style: StrokeStyle(lineWidth: Constants.strokeWidth))
                            .foregroundColor(.gray)
                            .cornerRadius(Constants.cornerRadius)
                    )
                
                HStack {
                    Image("icSnippetFileWhite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Constants.imageRegularHeight)
                        .padding(.leading, Constants.imageLeadingPadding)
                    
                    VStack(
                        alignment: .leading,
                        spacing: .zero
                    ) {
                        Text(viewModel.snippet.title)
                            .font(.system(size: 13))
                            .lineLimit(Constants.lineLimit)
                            .padding(.bottom, Constants.smallPadding / 4)
                        
                        Text(viewModel.snippet.summary)
                            .font(.system(size: 11))
                            .opacity(Layout.mediumOpacity)
                            .lineLimit(Constants.lineLimit)
                            .padding(.bottom, Constants.smallPadding)
                    }
                    .padding(.leading, Constants.smallPadding)
                    
                    Spacer()
                }
                .makeVisible(
                    viewModel.type == .large,
                    removed: true
                )
                
                VStack(
                    alignment: .center,
                    spacing: .zero
                ) {
                    Image("icSnippetFileWhite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Constants.imageSmallHeight)
                    
                    Text(viewModel.snippet.title)
                        .font(.system(size: 11))
                        .lineLimit(Constants.lineLimit)
                        .padding(Constants.smallPadding)
                }
                .makeVisible(
                    viewModel.type == .normal,
                    removed: true
                )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(
            width: viewModel.type == .large ? Constants.windowSize.width : Constants.smallWindowWidth,
            height: Constants.windowSize.height,
            alignment: .leading
        )
        .cornerRadius(Constants.cornerRadius)
        .shadow(
            color: Color.black.opacity(Constants.tinyOpacity),
            radius: Constants.shadowRadius,
            x: Constants.shadowPosition.x,
            y: Constants.shadowPosition.y
        )
    }
    
}
