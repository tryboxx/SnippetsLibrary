//
//  TextFieldStyleModifier.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 11/09/2021.
//

import SwiftUI

struct TextFieldStyleModifier: ViewModifier {
    
    // MARK: - Stored Properties
    
    let type: SnippetDetailsViewType
    
    // MARK: - Views

    @ViewBuilder
    func body(content: Content) -> some View {
        if type == .create {
            content
                .textFieldStyle(DefaultTextFieldStyle())
        } else {
            content
                .textFieldStyle(PlainTextFieldStyle())
        }
    }
    
}
