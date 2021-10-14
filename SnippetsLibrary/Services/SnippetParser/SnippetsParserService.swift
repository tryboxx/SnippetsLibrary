//
//  SnippetsParserService.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/09/2021.
//

import SwiftUI
import Combine

protocol SnippetsParserService {
    func createSnippet(_ snippet: Snippet) -> AnyPublisher<SnippetPlist, SnippetsParserServiceError>
    func removeSnippet(_ snippet: Snippet) -> AnyPublisher<Void, SnippetsParserServiceError>
    func writeSnippetsToPath(
        type: SnippetWriteType,
        snippets: [Snippet],
        uploadingStatus: Binding<UploadingStatus>,
        progressValue: Binding<CGFloat>,
        completion: @escaping () -> Void,
        onError: () -> Void
    )
}

final class SnippetsParserServiceImpl: SnippetsParserService {
    
    // MARK: - Stored Properties
    
    private let fileManager = FileManager.default
    
    private var snippetsDirectoryURL: URL? {
        let directoryURLs = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )
        
        guard let directoryURL = directoryURLs.first else {
            return nil
        }
        
        let directory = directoryURL.appendingPathComponent("CodeSnippets")
        
        guard !fileManager.fileExists(atPath: directory.path) else {
            return directory
        }
        
        do {
            try fileManager.createDirectory(
                at: directoryURL.appendingPathComponent("CodeSnippets"),
                withIntermediateDirectories: false,
                attributes: nil
            )
        } catch {
            debugPrint(SnippetsParserServiceError.unableToCreateDirectory)
        }
        
        return directory
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    
    func createSnippet(_ snippet: Snippet) -> AnyPublisher<SnippetPlist, SnippetsParserServiceError> {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        guard let snippetsDirectoryURL = self.snippetsDirectoryURL else {
            return Fail(error: .unableToFindSnippetsDirectory)
                .eraseToAnyPublisher()
        }
        
        return Future<SnippetPlist, SnippetsParserServiceError> { promise in
            do {
                let plistSnippet = SnippetPlist(from: snippet)
                let data = try encoder.encode(plistSnippet)
                let filename = snippetsDirectoryURL.appendingPathComponent("\(snippet.id).codesnippet")
                try data.write(to: filename, options: [])
                promise(.success(plistSnippet))
            } catch {
                promise(.failure(.unableToSaveSnippet))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func removeSnippet(_ snippet: Snippet) -> AnyPublisher<Void, SnippetsParserServiceError> {
        guard let snippetsDirectoryURL = self.snippetsDirectoryURL else {
            return Fail(error: .unableToFindSnippetsDirectory)
                .eraseToAnyPublisher()
        }
        
        return Future<Void, SnippetsParserServiceError> { promise in
            do {
                let fileURL = snippetsDirectoryURL.appendingPathComponent("\(snippet.id).codesnippet")
                try self.fileManager.removeItem(at: fileURL)
                promise(.success(()))
            } catch {
                promise(.failure(.unableToRemoveSnippet))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Writing
    
    func writeSnippetsToPath(
        type: SnippetWriteType,
        snippets: [Snippet],
        uploadingStatus: Binding<UploadingStatus>,
        progressValue: Binding<CGFloat>,
        completion: @escaping () -> Void,
        onError: () -> Void
    ) {
        switch type {
        case .download:
            write(
                sourceDirectory: .downloadsDirectory,
                componentsSeparator: "Library/",
                snippets: snippets,
                uploadingStatus: uploadingStatus,
                progressValue: progressValue,
                message: "Where do you want to save the snippet?",
                directoryPathSuffix: "Downloads",
                completion: completion,
                onError: onError
            )
        case .uploadToXcode:
            write(
                sourceDirectory: .libraryDirectory,
                componentsSeparator: "Containers/",
                snippets: snippets,
                uploadingStatus: uploadingStatus,
                progressValue: progressValue,
                message: "Confirm Xcode user snippets directory",
                directoryPathSuffix: "Developer/Xcode/UserData/CodeSnippets",
                completion: completion,
                onError: onError
            )
        }
    }
    
    private func write(
        sourceDirectory: FileManager.SearchPathDirectory,
        componentsSeparator: String,
        snippets: [Snippet],
        uploadingStatus: Binding<UploadingStatus>? = nil,
        progressValue: Binding<CGFloat>? = nil,
        message: String,
        directoryPathSuffix: String,
        completion: (() -> Void)? = nil,
        onError: () -> Void
    ) {
        let fileManager = FileManager.default
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let directoryURLs = fileManager.urls(
            for: sourceDirectory,
            in: .userDomainMask
        )
        
        guard
            let containerDirectoryURL = directoryURLs.first,
            let sourceDirectory = containerDirectoryURL.absoluteString.components(separatedBy: componentsSeparator).first,
            let userSourceDirectory = snippetSourceDirectoryURL(
                    withDirectory: sourceDirectory,
                    message: message,
                    directoryPathSuffix: directoryPathSuffix,
                    uploadingStatus: uploadingStatus
                )
        else {
            uploadingStatus?.wrappedValue = .error
            return
        }
        
        for (index, snippet) in snippets.enumerated() {
            DispatchQueue.main.async {
                uploadingStatus?.wrappedValue = .uploading
                progressValue?.wrappedValue = (CGFloat(index + 1) / CGFloat(snippets.count))
            }
            do {
                let plistSnippet = SnippetPlist(from: snippet)
                let data = try encoder.encode(plistSnippet)
                let filePath = userSourceDirectory.appendingPathComponent("\(snippet.id).codesnippet")
                try data.write(to: filePath, options: [])
            } catch {
                onError()
            }
        }
        
        completion?()
    }
    
    private func snippetSourceDirectoryURL(
        withDirectory userDirectory: String,
        message: String,
        directoryPathSuffix: String,
        uploadingStatus: Binding<UploadingStatus>? = nil
    ) -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.message = message
        openPanel.prompt = "Confirm"
        openPanel.allowedFileTypes = ["none"]
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.directoryURL = URL(string: "\(userDirectory)\(directoryPathSuffix)")

        let response = openPanel.runModal()
        if response != .OK {
            uploadingStatus?.wrappedValue = .error
            return nil
        } else {
            return openPanel.urls.first
        }
    }
    
}

extension SnippetsParserService {
    
    func writeToPath(
        type: SnippetWriteType,
        snippets: [Snippet],
        uploadingStatus: Binding<UploadingStatus>? = nil,
        progressValue: Binding<CGFloat>? = nil,
        completion: (() -> Void)? = nil,
        onError: () -> Void
    ) {
        writeSnippetsToPath(
            type: type,
            snippets: snippets,
            uploadingStatus: uploadingStatus ?? .constant(.initializing),
            progressValue: progressValue ?? .constant(.zero),
            completion: completion ?? {},
            onError: onError
        )
    }
    
}
