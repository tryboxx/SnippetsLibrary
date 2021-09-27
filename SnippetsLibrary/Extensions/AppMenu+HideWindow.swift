//
//  AppMenu+HideWindow.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 27/09/2021.
//

import SwiftUI

extension AppMenu: NSWindowDelegate {
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.hide(nil)
        return false
    }
    
}
