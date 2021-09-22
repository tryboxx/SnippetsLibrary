//
//  CustomCodeTheme.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 13/09/2021.
//

import SwiftUI
import Sourceful

struct CustomCodeTheme: SourceCodeTheme {
    
    private static var lineNumbersColor: NSColor = .clear
    public let lineNumbersStyle: LineNumbersStyle? = nil
    public let gutterStyle: GutterStyle = GutterStyle(backgroundColor: Color.clear, minimumWidth: 0)
    public let font = NSFont.monospacedSystemFont(ofSize: 15, weight: .regular)
    
    public let backgroundColor = Color(red: 41/255.0, green: 42/255, blue: 48/255, alpha: 1.0)
    
    public func color(for syntaxColorType: SourceCodeTokenType) -> NSColor {
        switch syntaxColorType {
        case .plain:
            return Color(red: 223/255, green: 223/255, blue: 224/255, alpha: 1.0)
        case .number:
            return Color(red: 214/255, green: 202/255, blue: 134/255, alpha: 1.0)
        case .string:
            return Color(red: 239/255, green: 136/255, blue: 118/255, alpha: 1.0)
        case .identifier:
            return Color(red: 171/255, green: 131/255, blue: 228/255, alpha: 1.0)
        case .keyword:
            return Color(red: 238/255, green: 130/255, blue: 176/255, alpha: 1.0)
        case .comment:
            return Color(red: 129/255.0, green: 140/255.0, blue: 150/255.0, alpha: 1.0)
        case .editorPlaceholder:
            return .gray
        }
    }
    
    public init() {}
    
}
