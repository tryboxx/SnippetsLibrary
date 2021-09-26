//
//  View+Displayed.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import SwiftUI

extension View {
    
    func makeDisplayed(
        with visible: Binding<Bool>,
        imageName: String? = nil,
        title: String,
        subtitle: String? = nil,
        displayingTime: Double = 2,
        state: ToastViewState = .none
    ) -> some View {
        self.overlay(
            ToastView(
                imageName: imageName,
                title: title,
                subtitle: subtitle,
                state: state
            )
            .offset(y: visible.wrappedValue ? -((Layout.defaultWindowSize.height / 2) - Layout.smallPadding) : 0)
            .makeVisible(
                visible.wrappedValue,
                removed: true
            )
            .animation(.default)
            .onChange(of: visible.wrappedValue) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + displayingTime) {
                    withAnimation {
                        visible.wrappedValue = false
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    visible.wrappedValue = false
                }
            }
        )
    }
    
}
