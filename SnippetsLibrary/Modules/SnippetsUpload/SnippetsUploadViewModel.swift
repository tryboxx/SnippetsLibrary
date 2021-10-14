//
//  SnippetsUploadViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 26/09/2021.
//

import AppKit
import Combine

final class SnippetsUploadViewModel: ObservableObject {
    
    private enum Constants {
        static let midValue: CGFloat = 0.5
        static let fullValue: CGFloat = 1.0
    }
    
    // MARK: - Stored Properties
    
    private(set) var snippets: [Snippet]
    
    @Published internal var progressValue: CGFloat = .zero
    @Published private(set) var shouldDismissView = false
    @Published internal var uploadingStatus: UploadingStatus = .initializing
    
    private let snippetsParserService: SnippetsParserService
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(
        snippets: [Snippet],
        snippetsParserService: SnippetsParserService = DIContainer.snippetsParserService
    ) {
        self.snippets = snippets
        self.snippetsParserService = snippetsParserService
    }
    
    // MARK: - Methods
    
    internal func uploadSnippetsToXcode() {
        snippetsParserService.writeToPath(
            type: .uploadToXcode,
            snippets: snippets
        ) {
            self.uploadingStatus = .uploading
            self.progressValue = Constants.midValue
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.midValue) {
                self.progressValue = Constants.fullValue
                self.finishUpload()
            }
        } onError: {
            self.uploadingStatus = .error
        }
    }
    
    private func finishUpload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.fullValue) {
            self.uploadingStatus = .done
        }
    }
    
}
