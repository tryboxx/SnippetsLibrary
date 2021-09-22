//
//  StartView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

struct StartView: View {
    
    private enum Constants {
        static let logoImageHeight: CGFloat = 80
        static let devToolsImageHeight: CGFloat = 50
        static let devToolsImageBottomPadding: CGFloat = -34.0
        static let titleTopPadding: CGFloat = 40.0
        static let menuItemsSpacing: CGFloat = 12.0
    }
    
    // MARK: - Stored Properties
    
    @ObservedObject private(set) var viewModel: StartViewModel
    
    // MARK: - Views
    
    var body: some View {
        HSplitView {
            VStack(spacing: .zero) {
                HStack {
                    Button {
                        viewModel.closeView()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 10.0, weight: .medium))
                    }
                    
                    Spacer()
                }
                .padding()
                .buttonStyle(PlainButtonStyle())
                
                ZStack(alignment: .bottomTrailing) {
                    HStack(spacing: .zero) {
                        Image("icLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: Constants.logoImageHeight)
                            .padding(.top)
                            .padding(.trailing, Layout.largePadding * 2)
                    }
                    
                    Image("icDevTools")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Constants.devToolsImageHeight)
                        .padding(.bottom, Constants.devToolsImageBottomPadding)
                }
                
                Text("Snippets Library")
                    .font(.system(size: 40.0, weight: .regular))
                    .padding(.top, Constants.titleTopPadding)
                
                Text("Version \(NSApplication.appVersion)")
                    .font(.system(size: 13.0, weight: .light))
                    .foregroundColor(Color.primary.opacity(Layout.mediumOpacity))
                    .padding(.top, Layout.smallPadding)
                
                Spacer()
                
                VStack(
                    alignment: .leading,
                    spacing: Constants.menuItemsSpacing
                ) {
                    StartViewMenuItem(type: .create) {
                        if viewModel.activeAppView != .snippetsLibrary(nil) {
                            viewModel.activeAppView = .create
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.activeAppSheet = .snippetDetails(Snippet(), .create)
                            }
                        } else {
                            viewModel.activeAppSheet = .snippetDetails(Snippet(), .create)
                        }
                    }
                    
                    StartViewMenuItem(type: .importSnippet) {
                        viewModel.activeAppView = .importSnippet
                    }
                    
                    StartViewMenuItem(type: .open) {
                        viewModel.activeAppView = .snippetsLibrary(nil)
                    }
                }
                .padding(.leading, Layout.largePadding * 2)
                .padding(.trailing, Layout.largePadding)
                
                Spacer()
            }
            .frame(width: Layout.defaultWindowSize.width * 0.62)
            .ignoresSafeArea()
            
            StartViewRecentSnippetsView(
                recentSnippets: $viewModel.recentSnippets,
                activeAppView: $viewModel.activeAppView
            )
        }
        .frame(
            width: Layout.defaultWindowSize.width,
            height: Layout.defaultWindowSize.height
        )
    }
    
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(viewModel: StartViewModel(activeAppView: .constant(nil), activeAppSheet: .constant(nil)))
    }
}
