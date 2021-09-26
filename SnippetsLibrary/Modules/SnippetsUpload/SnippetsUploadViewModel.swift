//
//  SnippetsUploadViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 26/09/2021.
//

import Foundation
import Combine

final class SnippetsUploadViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    private(set) var snippets: [Snippet]
    
    @Published internal var progressValue: CGFloat = 0.0
    @Published private(set) var shouldDismissView = false
    @Published internal var uploadingStatus: UploadingStatus = .initializing
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(snippets: [Snippet]) {
        self.snippets = snippets
    }
    
    // MARK: - Methods
    
    internal func uploadSnippetsToXcode() {
        let fileManager = FileManager.default
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let directoryURLs = fileManager.urls(
            for: .libraryDirectory,
            in: .userDomainMask
        )
        
        guard let directoryURL = directoryURLs.first else {
            uploadingStatus = .error
            return
        }
        
        let xcodeUserSnippetsDirectory = directoryURL.appendingPathComponent("Developer/Xcode/UserData/CodeSnippets")
        
        for (index, snippet) in snippets.enumerated() {
            uploadingStatus = .uploading
            
            DispatchQueue.main.async {
                self.progressValue = CGFloat(index + 1) / CGFloat(self.snippets.count)
            }
            do {
                let plistSnippet = SnippetPlist(from: snippet)
                let data = try encoder.encode(plistSnippet)
                let filePath = xcodeUserSnippetsDirectory.appendingPathComponent("\(snippet.id).codesnippet")
                try data.write(to: filePath, options: [])
            } catch {
                self.uploadingStatus = .error
            }
        }
        
        guard uploadingStatus != .error else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.progressValue = 1.0
            self.uploadingStatus = .done
        }
    }
    
}
