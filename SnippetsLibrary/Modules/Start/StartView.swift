//
//  StartView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

struct StartView: View {
    
    private enum Constants {
        static let logoImageHeight: CGFloat = 130
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
                
                Image("icLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: Constants.logoImageHeight)
                    .padding(.top, Layout.smallPadding)
                
                Text("Snippets Library")
                    .font(.system(size: 40.0, weight: .regular))
                
                Text("Version \(NSApplication.appVersion)")
                    .font(.system(size: 13.0, weight: .light))
                    .foregroundColor(Color.primary.opacity(Layout.mediumOpacity))
                    .padding(.top, Layout.smallPadding / 2)
                
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
