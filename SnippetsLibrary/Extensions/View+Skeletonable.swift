//
//  View+Skeletonable.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import SwiftUI
import SwiftUISkeleton

extension View {
    
    func makeSkeletonable(
        animating: Bool,
        isBottomView: Bool = false
    ) -> some View {
        self.skeleton(
            with: animating,
            shape: RoundedRectangle(cornerRadius: 4.0),
            animation: .linear(duration: 1)
                .repeatForever(autoreverses: true),
            gradient:
                Gradient(
                    colors: [
                        Color(isBottomView ? "skeletonLight" : "skeletonRegular"),
                        Color(isBottomView ? "skeletonThin": "skeletonLight")
                    ]
                )
        )
    }
    
}
