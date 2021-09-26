//
//  ToastView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import SwiftUI

enum ToastViewState {
    case success
    case failure
    case none
    
    var color: Color {
        switch self {
        case .success: return Color.green
        case .failure: return Color.red
        case .none: return Color.primary
        }
    }
}

struct ToastView: View {
    
    private enum Constans {
        static let spacing: CGFloat = 16.0
        static let imageSize: CGFloat = 22.0
        static let lineLimit = 1
        static let height: CGFloat = 44.0
        static let shadowOpacity = 0.08
        static let shadowRadius: CGFloat = 8.0
        static let shadowOffset: CGFloat = 4.0
    }
    
    // MARK: - Stored Properties
    
    @Environment(\.colorScheme) var colorScheme
    
    let imageName: String?
    let title: String
    let subtitle: String?
    let state: ToastViewState?
    
    // MARK: - Views
    
    var body: some View {
        HStack(spacing: Constans.spacing) {
            Image(systemName: imageName ?? "")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(
                    width: Constans.imageSize,
                    height: Constans.imageSize
                )
                .foregroundColor(state?.color)
                .makeVisible(
                    imageName != nil,
                    removed: true
                )
            
            VStack {
                Text(title)
                    .lineLimit(Constans.lineLimit)
                    .font(.headline)
                    .foregroundColor(Color.primary)
                
                Text(subtitle ?? "")
                    .lineLimit(Constans.lineLimit)
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
                    .makeVisible(
                        subtitle != nil,
                        removed: true
                    )
            }
            .padding(imageName == nil ? .horizontal : .trailing)
        }
        .padding(.horizontal)
        .frame(height: Constans.height)
        .background(colorScheme == .dark ? Color("darkGrey") : Color.white)
        .cornerRadius(Constans.height / 2)
        .shadow(
            color: Color.black.opacity(Constans.shadowOpacity),
            radius: Constans.shadowRadius,
            x: .zero,
            y: Constans.shadowOffset
        )
    }
    
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(imageName: nil, title: "", subtitle: nil, state: ToastViewState.none)
    }
}
