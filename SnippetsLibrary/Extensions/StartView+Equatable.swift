//
//  StartView+Equatable.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import Foundation

extension StartView: Equatable {
    
    static func == (lhs: StartView, rhs: StartView) -> Bool {
        return lhs.viewModel.activeAppView == rhs.viewModel.activeAppView
    }
    
}
