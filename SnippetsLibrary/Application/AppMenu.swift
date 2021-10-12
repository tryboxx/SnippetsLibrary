//
//  AppMenu.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 27/09/2021.
//

import SwiftUI

final class AppMenu: NSMenu {
    
    // MARK: - Stored Properties
    
    private lazy var applicationName = ProcessInfo.processInfo.processName
    
    private var statusItem: NSMenuItem {
        NSMenuItem(
            title: "Status",
            action: nil,
            keyEquivalent: ""
        )
    }
    
    private var aboutItem: NSMenuItem {
        let item = NSMenuItem(
            title: "",
            action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
            keyEquivalent: ""
        )
        item.attributedTitle = NSAttributedString(
            string: "About \(applicationName)",
            attributes: [NSAttributedString.Key.font : NSFont.systemFont(ofSize: 13.0)]
        )
        return item
    }
    
    private var docsItem: NSMenuItem {
        let item = NSMenuItem(
            title: "",
            action: nil,
            keyEquivalent: ""
        )
        item.attributedTitle = NSAttributedString(
            string: "Developer Documentation...",
            attributes: [NSAttributedString.Key.font : NSFont.systemFont(ofSize: 13.0)]
        )
        return item
    }
    
    private var quitItem: NSMenuItem {
        let item = NSMenuItem(
            title: "",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        item.attributedTitle = NSAttributedString(
            string: "Quit \(applicationName)",
            attributes: [NSAttributedString.Key.font : NSFont.systemFont(ofSize: 13.0)]
        )
        return item
    }
    
    // MARK: - Life Cycle

    override init(title: String) {
        super.init(title: title)
        
        setupMenuItems()
        NSApplication.shared.windows.first?.delegate = self
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    private func setupMenuItems() {
        items = [
            statusItem,
            NSMenuItem.separator(),
            aboutItem,
            docsItem,
            NSMenuItem.separator(),
            quitItem
        ]
    }
    
}
