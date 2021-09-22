//
//  VisualEffectView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    
    // MARK: - Stored Properties
    
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    // MARK: - Methods
    
    internal func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }
    
    internal func updateNSView(
        _ visualEffectView: NSVisualEffectView,
        context: Context
    ) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
    
}
