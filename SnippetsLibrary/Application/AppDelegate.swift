//
//  AppDelegate.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI
import Firebase

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Stored Properties
    
    @Environment(\.openURL) var openURL
    
    internal var statusBarItem: NSStatusItem?
    internal var statusView: NSView?
    internal var menu: AppMenu?
    
    // MARK: - Methods
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        FirebaseApp.configure()
        setupMenuItems()
        return
    }
    
}
