//
//  AppDelegate+NSMenuDelegate.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 27/09/2021.
//

import SwiftUI

extension AppDelegate: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        setupStatusView(for: menu)
    }
    
    func menuDidClose(_ menu: NSMenu) {}
    
    internal func setupMenuItems() {
        menu = AppMenu()
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusBarItem?.menu = menu
        menu?.delegate = self
        
        if let item = menu?.items.first(where: { $0.title == "Developer Documentation..." }) {
            item.action = #selector(openDocsURL(_:))
        }
        
        if let button = self.statusBarItem?.button {
            button.image = NSImage(named: "icLogoStatusBar")
        }
    }
    
    private func setupStatusView(for menu: NSMenu) {
        if let item = menu.items.first {
            statusView = NSHostingView(rootView: StatusView())
            setupItemView(
                menu: menu,
                item: item
            )
        }
    }
    
    private func setupItemView(
        menu: NSMenu,
        item: NSMenuItem
    ) {
        statusView?.frame = CGRect(
            x: .zero,
            y: .zero,
            width: 250.0,
            height: 170.0
        )
        item.view = statusView
    }
    
    @objc private func openDocsURL(_ sender: Any) {
        let urlFactory = DIContainer.urlFactory
        let docsURL = urlFactory.getURL(withType: .docs)
        guard let safeURL = docsURL else { return }
        openURL(safeURL)
    }
    
}
