//
//  View+Visibility.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

extension View {
    
    @ViewBuilder func makeVisible(
        _ visible: Bool,
        removed: Bool = false
    ) -> some View {
        if !visible {
            if !removed {
                self.hidden()
            }
        } else {
            self
        }
    }
    
}
