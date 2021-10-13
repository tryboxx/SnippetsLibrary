//
//  SnippetFileCardViewModel.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

final class SnippetFileCardViewModel: ObservableObject {
    
    // MARK: - Stored Properties
    
    private(set) var snippet: Snippet
    private(set) var state: SnippetFileCardViewState
    
    @Published internal var titleText = ""
    @Published internal var contentText = ""
    @Binding internal var appAlert: AppAlert?
    @Binding internal var activeSheet: AppSheet?
    
    private(set) var onDelete: (() -> Void)? = nil
    
    // MARK: - Initialization
    
    init(
        snippet: Snippet?,
        state: SnippetFileCardViewState,
        activeSheet: Binding<AppSheet?>,
        appAlert: Binding<AppAlert?>,
        onDelete: (() -> Void)? = nil
    ) {
        self.snippet = snippet ?? Snippet()
        self.state = state
        self._activeSheet = activeSheet
        self._appAlert = appAlert
        self.onDelete = onDelete
        
        setup()
    }
    
    // MARK: - Methods
    
    internal func downloadSnippet() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let directoryURLs = FileManager.default.urls(
            for: .downloadsDirectory,
            in: .userDomainMask
        )
        
        guard
            let containerDirectoryURL = directoryURLs.first,
            let userDirectory = containerDirectoryURL.absoluteString.components(separatedBy: "Library/").first,
            let snippetDownloadDirectory = snippetDownloadDirectoryURL(with: userDirectory)
        else {
            return
        }
        
        DispatchQueue.main.async {
            do {
                let plistSnippet = SnippetPlist(from: self.snippet)
                let data = try encoder.encode(plistSnippet)
                let filePath = snippetDownloadDirectory.appendingPathComponent("\(self.snippet.id).codesnippet")
                try data.write(to: filePath, options: .atomic)
            } catch {
                self.appAlert = .snippetDownload
            }
        }
    }
    
    internal func linesCount() -> Int {
        return contentText.numberOfLines()
    }
    
    internal func openSnippetDetails() {
        activeSheet = .snippetDetails(snippet, .edit)
    }
    
    private func snippetDownloadDirectoryURL(with userDirectory: String) -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.message = "Where do you want to save the snippet?"
        openPanel.prompt = "Confirm"
        openPanel.allowedFileTypes = ["none"]
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.directoryURL = URL(string: "\(userDirectory)Downloads")

        let response = openPanel.runModal()
        if response != .OK {
            return nil
        } else {
            return openPanel.urls.first
        }
    }
    
    private func setup() {
        titleText = snippet.title
        contentText = snippet.content
        snippet.tags = snippet.tags?.isEmpty == true ? ["SwiftUI"] : []
    }
    
}
