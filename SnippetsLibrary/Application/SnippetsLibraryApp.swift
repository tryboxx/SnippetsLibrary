//
//  SnippetsLibraryApp.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

@main
struct SnippetsLibraryApp: App {
    
    // MARK: - Stored Properties

    @Environment(\.openURL) var openURL
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var activeAppView: ActiveAppView? = nil
    @State private var activeAppSheet: AppSheet? = nil
    @State private var shouldBeDisabled = false
    
    // MARK: - Views
    
    var body: some Scene {
        WindowGroup {
            AppView(
                activeAppView: $activeAppView,
                activeAppSheet: $activeAppSheet,
                shouldBeDisabled: $shouldBeDisabled
            )
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .onChange(of: activeAppView) {
            shouldBeDisabled = ($0 == .snippetsLibrary(nil))
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Add New Code Snippet...") {
                    if activeAppView != .snippetsLibrary(nil) {
                        activeAppView = .create
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            activeAppSheet = .snippetDetails(Snippet(), .create)
                        }
                    } else {
                        activeAppSheet = .snippetDetails(Snippet(), .create)
                    }
                }
                
                Button("Import Local Snippet...") {
                    activeAppView = .importSnippet
                }
                
                DisabledCommandGroupButton(
                    text: "Open Snippets Library...",
                    shouldBeDisabled: $shouldBeDisabled
                ) {
                    activeAppView = .snippetsLibrary(nil)
                }
            }
            
            CommandGroup(replacing: .help) {
                Button("Report issue...") {
                    composeEmail()
                }
                
                Button("Show User Guides") {
                    openURL(url: DIContainer.urlFactory.getURL(withType: .userGuides))
                }
            }
            
            CommandGroup(replacing: .windowList) {
                Button("Developer Documentation") {
                    openURL(url: DIContainer.urlFactory.getURL(withType: .docs))
                }
                .keyboardShortcut(
                    "0",
                    modifiers: [.command, .shift])
            }
        }
    }
    
    // MARK: - Methods
    
    private func composeEmail() {
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)
        service?.recipients = ["support@swiftdevtools.com"]
        service?.subject = "Snippets Library Issue"
        service?.perform(withItems: ["Please describe your problem here..."])
    }
    
    private func openURL(url: URL?) {
        guard let safeURL = url else { return }
        openURL(safeURL)
    }
    
}
