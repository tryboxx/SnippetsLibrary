//
//  SnippetsUploadViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 26/09/2021.
//

import AppKit
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
        
        guard
            let containerDirectoryURL = directoryURLs.first,
            let libraryDirectory = containerDirectoryURL.absoluteString.components(separatedBy: "Containers/").first,
            let xcodeUserSnippetsDirectory = xcodeUserSnippetsDirectoryURL(with: libraryDirectory)
        else {
            uploadingStatus = .error
            return
        }
        
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
    
    private func xcodeUserSnippetsDirectoryURL(with libraryDirectory: String) -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.message = "Confirm Xcode user snippets directory"
        openPanel.prompt = "Confirm"
        openPanel.allowedFileTypes = ["none"]
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.directoryURL = URL(string: "\(libraryDirectory)Developer/Xcode/UserData/CodeSnippets")

        let response = openPanel.runModal()
        if response != .OK {
            uploadingStatus = .error
            return nil
        } else {
            return openPanel.urls.first
        }
    }
    
}
