//
//  AppView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import SwiftUI

struct AppView: View {
    
    private enum Constants {
        static let statusWindowClassName = "NSStatusBarWindow"
        static let delay = DispatchTime.now() + 0.01
    }
    
    // MARK: - Stored Properties
    
    @Environment(\.scenePhase) var scenePhase
    
    @Binding internal var activeAppView: ActiveAppView?
    @Binding internal var activeAppSheet: AppSheet?
    @Binding internal var shouldBeDisabled: Bool
    
    @ObservedObject private var networkObserver = NetworkObserver()
    @State private var shouldShowNetworkAlert = false
    
    // MARK: - Views
    
    var body: some View {
        showActiveAppView()
            .onChange(of: networkObserver.isConnected) { _ in
                withAnimation {
                    shouldShowNetworkAlert.toggle()
                }
            }
            .onOpenURL {
                openSnippet(fromURL: $0)
            }
            .makeDisplayed(
                with: $shouldShowNetworkAlert,
                imageName: "network",
                title: networkObserver.isConnected ? "Connected" : "No connection",
                state: networkObserver.isConnected ? .success : .failure
            )
    }
    
    // MARK: - Methods
    
    @ViewBuilder
    private func showActiveAppView() -> some View {
        switch activeAppView {
        case .create:
            SnippetsLibraryView(
                viewModel: SnippetsLibraryViewModel(),
                activeSheet: $activeAppSheet
            )
            .onAppear {
                updateSystemButtons(hidden: false)
            }
        case .importSnippet:
            SnippetImportView(viewModel: SnippetImportViewModel(activeAppView: $activeAppView))
                .onAppear {
                    updateSystemButtons(hidden: false)
                }
        case let .snippetsLibrary(snippetId):
            SnippetsLibraryView(
                viewModel: SnippetsLibraryViewModel(activeSnippetId: snippetId),
                activeSheet: $activeAppSheet
            )
            .onAppear {
                updateSystemButtons(hidden: false)
            }
        case .none:
            StartView(
                viewModel: StartViewModel(
                    activeAppView: $activeAppView,
                    activeAppSheet: $activeAppSheet
                )
            )
            .onChange(of: scenePhase) {
                guard $0 == .active else { return }
                
                updateSystemButtons(hidden: true)
            }
        }
    }
    
    private func updateSystemButtons(hidden: Bool) {
        for window in NSApplication.shared.windows {
            window.standardWindowButton(.zoomButton)?.isHidden = hidden
            window.standardWindowButton(.miniaturizeButton)?.isHidden = hidden
            window.standardWindowButton(.closeButton)?.isHidden = hidden
        }
    }
    
    private func openSnippet(fromURL url: URL) {
        closeWindowsIfVisible()
        let snippetId = url.absoluteString.replacingOccurrences(of: "widget://", with: "")
        
        DispatchQueue.main.asyncAfter(deadline: Constants.delay) {
            NSApplication.shared.windows.first?.orderFront(nil)
            activeAppView = .snippetsLibrary(snippetId)
        }
    }
    
    private func closeWindowsIfVisible() {
        for window in NSApplication.shared.windows where window.className != Constants.statusWindowClassName {
            DispatchQueue.main.async {
                window.close()
            }
        }
    }
    
}


struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(activeAppView: .constant(nil), activeAppSheet: .constant(nil), shouldBeDisabled: .constant(false))
    }
}
