//
//  DisabledCommandGroupButton.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 23/09/2021.
//

import SwiftUI

struct DisabledCommandGroupButton: View {
    
    // MARK: - Stored Properties
    
    let text: String
    @Binding private(set) var shouldBeDisabled: Bool
    let type: DisabledCommandGroupButtonType
    let onTap: () -> Void
    
    // MARK: - Views
    
    var body: some View {
        Button(
            text,
            action: onTap
        )
        .disabled(type == .openLibrary ? shouldBeDisabled : !shouldBeDisabled)
    }
    
}

struct DisabledCommandGroupButton_Previews: PreviewProvider {
    static var previews: some View {
        DisabledCommandGroupButton(text: "", shouldBeDisabled: .constant(false), type: .openLibrary) {}
    }
}
