//
//  SnippetCreationManualView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 03/11/2021.
//

import SwiftUI

struct SnippetCreationManualView: View {
    
    private enum Constants {
        static let imageHeight: CGFloat = 38.0
        static let lineSpacing: CGFloat = 5.0
        static let viewSize = CGSize(width: 350.0, height: 400.0)
        static let cornerRadius: CGFloat = 12.0
    }
    
    // MARK: - Views
    
    var body: some View {
        VStack {
            Image("icSnippetFileWhite")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: Constants.imageHeight)
            
            Text("How to create a snippet?")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, Layout.smallPadding)
            
            Text("To maintain consistency and unify all code snippets in the Snippets Library, follow this two main rules:")
                .font(.system(size: 11, weight: .medium))
                .padding(.bottom)
                .opacity(Layout.mediumOpacity)
                .multilineTextAlignment(.center)
            
            Text(
                """
                ✅ Make sure, that your snippet is helpful, complete and contains only the necessary lines required for use.
                
                ✅ Enter the title, summary, supported platforms and scopes and remember, that the completion should be self-explaining.
                """
            )
            .lineSpacing(Constants.lineSpacing)
            .font(.system(size: 13))
            .multilineTextAlignment(.leading)
        }
        .padding(Layout.largePadding)
        .frame(
            width: Constants.viewSize.width,
            height: Constants.viewSize.height
        )
        .background(Color("defaultBackground"))
        .cornerRadius(Constants.cornerRadius)
    }
    
}

struct SnippetCreationManualView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetCreationManualView()
    }
}
