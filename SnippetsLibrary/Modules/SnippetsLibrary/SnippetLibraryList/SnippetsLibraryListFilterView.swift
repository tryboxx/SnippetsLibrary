//
//  SnippetsLibraryListFilterView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 01/10/2021.
//

import SwiftUI

struct SnippetsLibraryListFilterView: View {
    
    private enum Constants {
        static let dividerRotationDegree = 90.0
        static let viewHeight: CGFloat = 24.0
    }
    
    // MARK: - Stored Properites
    
    @Binding internal var selectedCategory: SnippetCategory?
    private let categories = SnippetCategory.allCases
    
    // MARK: - Views
    
    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            LazyHStack(spacing: .zero) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category.rawValue.capitalized)
                            .font(.system(size: 11.0))
                            .foregroundColor(selectedCategory == category ? Color.white : Color.primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, Layout.smallPadding)
                    .padding(.vertical, Layout.smallPadding / 4)
                    .background(
                        Capsule()
                            .foregroundColor(Color.accentColor)
                            .makeVisible(selectedCategory == category)
                    )
                    .padding(
                        .leading,
                        category == .view ? Layout.standardPadding : .zero
                    )
                    
                    Divider()
                        .rotationEffect(.degrees(Constants.dividerRotationDegree))
                }
                
                Button {
                    selectedCategory = nil
                } label: {
                    Text("Remove all filters")
                        .font(.system(size: 11.0))
                        .foregroundColor(Color.red)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, Layout.smallPadding)
            }
        }
        .frame(height: Constants.viewHeight)
    }
    
}

struct SnippetsLibraryListFilterView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsLibraryListFilterView(selectedCategory: .constant(nil))
    }
}
