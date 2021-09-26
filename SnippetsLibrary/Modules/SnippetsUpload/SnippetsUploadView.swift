//
//  SnippetsUploadView.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 26/09/2021.
//

import SwiftUI

struct SnippetsUploadView: View {
    
    private enum Constants {
        static let totalProgressValue: CGFloat = 1.0
    }
    
    // MARK: - Stored Properties
    
    @Environment (\.presentationMode) var presentationMode
    
    @StateObject internal var viewModel: SnippetsUploadViewModel
    
    // MARK: - Views
    
    var body: some View {
        VStack(spacing: Layout.standardPadding) {
            Spacer()
            
            Image(systemName: viewModel.uploadingStatus == .done ? "checkmark.circle.fill" : "xmark.octagon.fill")
                .font(.system(size: 56, weight: .regular))
                .foregroundColor(viewModel.uploadingStatus == .done ? Color.green : Color.red)
                .makeVisible(
                    viewModel.uploadingStatus != .uploading && viewModel.uploadingStatus != .initializing,
                    removed: true
                )
            
            Text(viewModel.uploadingStatus.title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color.primary)
            
            Text(viewModel.uploadingStatus.message)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(
                    Color.primary
                        .opacity(Layout.largeOpacity)
                )
                .multilineTextAlignment(.center)
                .padding(.top, -Layout.smallPadding)
                .makeVisible(
                    viewModel.uploadingStatus != .uploading && viewModel.uploadingStatus != .initializing,
                    removed: true
                )
            
            ProgressView(
                value: viewModel.progressValue,
                total: Constants.totalProgressValue,
                label: { EmptyView() },
                currentValueLabel: {
                    HStack {
                        Spacer()
                        
                        Text(viewModel.uploadingStatus.currentDescription)
                        
                        Spacer()
                    }
                    .padding(.top, Layout.smallPadding)
                }
            )
            .progressViewStyle(LinearProgressViewStyle(tint: Color.accentColor))
            .makeVisible(
                viewModel.uploadingStatus == .uploading || viewModel.uploadingStatus == .initializing,
                removed: true
            )
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button("Done") { presentationMode.wrappedValue.dismiss() }
            }
            .makeVisible(
                viewModel.uploadingStatus != .uploading && viewModel.uploadingStatus != .initializing,
                removed: true
            )
            .padding(.bottom)
        }
        .padding(.horizontal, Layout.largePadding)
        .frame(
            width: Layout.defaultWindowSize.width * 0.6,
            height: Layout.defaultWindowSize.height * 0.7
        )
        .onChange(of: viewModel.shouldDismissView) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                viewModel.uploadSnippetsToXcode()
            }
        }
    }
    
}

struct SnippetsUploadView_Previews: PreviewProvider {
    static var previews: some View {
        SnippetsUploadView(viewModel: SnippetsUploadViewModel(snippets: []))
    }
}
