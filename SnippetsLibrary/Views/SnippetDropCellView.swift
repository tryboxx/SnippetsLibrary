//
//  SnippetDropCellView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/09/2021.
//

import SwiftUI

struct SnippetDropCellView: View {
    
    // MARK: - Stored Properties
    
    let snippet: Snippet?
    
    // MARK: - Views
    
    var body: some View {
        VStack(spacing: .zero) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 36.0))
                .padding(.bottom, Layout.smallPadding)
            
            Text("Drop the snippet file here")
                .font(.system(size: 15.0))
        }
    }
    
}

struct SnippetDropCellView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetDropCellView(snippet: Snippet())
    }
}
