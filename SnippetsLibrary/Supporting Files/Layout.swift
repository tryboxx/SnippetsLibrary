//
//  Layout.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

struct Layout {
    static let screenWidth = NSScreen.main?.visibleFrame.width ?? 0
    static let screenHeight = NSScreen.main?.visibleFrame.height ?? 0
    
    static let defaultWindowSize = CGSize(width: 850, height: 460)
    
    static let zeroPadding: CGFloat = 0.0
    static let smallPadding: CGFloat = 8.0
    static let standardPadding: CGFloat = 16.0
    static let mediumPadding: CGFloat = 24.0
    static let largePadding: CGFloat = 32.0
    
    static let fullOpacity: Double = 1.0
    static let largeOpacity: Double = 0.75
    static let mediumOpacity: Double = 0.5
    static let tinyOpacity: Double = 0.25
    static let minimalOpacity: Double = 0.1
    static let zeroOpacity: Double = 0.0
}
