//
//  CustomCodeTheme.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 13/09/2021.
//

import SwiftUI
import Sourceful

struct CustomCodeTheme: SourceCodeTheme {
    
    private enum Constants {
        static let backgroundDarkColor = NSColor(red: 41/255, green: 42/255, blue: 48/255, alpha: 1.0)
        static let plainTypeLightColor = NSColor(red: 2/255, green: 2/255, blue: 2/255, alpha: 1.0)
        static let plainTypeDarkColor = NSColor(red: 223/255, green: 223/255, blue: 224/255, alpha: 1.0)
        static let numberTypeLightColor = NSColor(red: 40/255, green: 41/255, blue: 208/255, alpha: 1.0)
        static let numberTypeDarkColor = NSColor(red: 214/255, green: 202/255, blue: 134/255, alpha: 1.0)
        static let stringTypeLightColor = NSColor(red: 192/255, green: 62/255, blue: 41/255, alpha: 1.0)
        static let stringTypeDarkColor = NSColor(red: 239/255, green: 136/255, blue: 118/255, alpha: 1.0)
        static let identifierTypeLightColor = NSColor(red: 121/255, green: 82/255, blue: 178/255, alpha: 1.0)
        static let identifierTypeDarkColor = NSColor(red: 171/255, green: 131/255, blue: 228/255, alpha: 1.0)
        static let keywordTypeLightColor = NSColor(red: 160/255, green: 69/255, blue: 160/255, alpha: 1.0)
        static let keywordTypeDarkColor = NSColor(red: 238/255, green: 130/255, blue: 176/255, alpha: 1.0)
        static let commentColor = NSColor(red: 129/255.0, green: 140/255.0, blue: 150/255.0, alpha: 1.0)
        
        static let font = NSFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        static let gutterStyle = GutterStyle(backgroundColor: NSColor.clear, minimumWidth: 0)
    }
    
    // MARK: - Stored Properties
    
    private var colorScheme: ColorScheme = .dark
    
    private static var lineNumbersColor: NSColor = .clear
    
    internal let lineNumbersStyle: LineNumbersStyle? = nil
    internal let gutterStyle: GutterStyle = Constants.gutterStyle
    internal let font = Constants.font
    
    // MARK: - Computed Properties
    
    internal var backgroundColor: NSColor {
        return colorScheme == .dark ? Constants.backgroundDarkColor : NSColor.white
    }
    
    // MARK: - Initialization
    
    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
    
    // MARK: - Methods
    
    func color(for syntaxColorType: SourceCodeTokenType) -> NSColor {
        switch syntaxColorType {
        case .plain:
            return colorScheme == .dark ? Constants.plainTypeDarkColor : Constants.plainTypeLightColor
        case .number:
            return colorScheme == .dark ? Constants.numberTypeDarkColor : Constants.numberTypeLightColor
        case .string:
            return colorScheme == .dark ? Constants.stringTypeDarkColor : Constants.stringTypeLightColor
        case .identifier:
            return colorScheme == .dark ? Constants.identifierTypeDarkColor : Constants.identifierTypeLightColor
        case .keyword:
            return colorScheme == .dark ? Constants.keywordTypeDarkColor : Constants.keywordTypeLightColor
        case .comment:
            return Constants.commentColor
        case .editorPlaceholder:
            return colorScheme == .dark ? .gray : .lightGray
        }
    }
    
}
