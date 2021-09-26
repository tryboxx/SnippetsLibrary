//
//  StartViewMenuItem.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

struct StartViewMenuItem: View {
    
    // MARK: - Stored Properties
    
    let type: StartViewMenuItemType
    private(set) var onTap: () -> Void
    
    // MARK: - Views
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: Layout.standardPadding) {
                Image(systemName: type.systemImageName)
                    .font(.system(size: type.imageFontSize, weight: .light))
                    .foregroundColor(Color("accent"))
                
                VStack(
                    alignment: .leading,
                    spacing: .zero
                ) {
                    Text(type.title)
                        .font(.system(size: 13.0, weight: .semibold))
                    
                    Text(type.subtitle)
                        .font(.system(size: 13.0))
                        .foregroundColor(
                            Color.primary
                                .opacity(Layout.mediumOpacity)
                        )
                }
                .padding(.leading, type.leadingPadding)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

struct StartViewMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        StartViewMenuItem(type: .create) {}
    }
}
