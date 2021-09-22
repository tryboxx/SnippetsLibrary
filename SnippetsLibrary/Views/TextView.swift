//
//  TextView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import SwiftUI
import Sourceful

struct TextView: View {
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 5.0
        static let lineSpacing: CGFloat = 4.0
        static let softTabWidth: Int = 2
    }
    
    // MARK: - Stored Properties
    
    @Binding internal var text: String
    @State private(set) var isEditable = true
    
    // MARK: - Views
    
    var body: some View {
        SourceCodeTextEditor(text: $text)
    }
    
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(text: .constant(""))
    }
}
