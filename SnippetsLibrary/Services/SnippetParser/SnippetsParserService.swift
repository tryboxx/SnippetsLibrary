//
//  SnippetsParserService.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/09/2021.
//

import Foundation
import Combine

protocol SnippetsParserService {
    func createSnippet(_ snippet: Snippet) -> AnyPublisher<SnippetPlist, SnippetsParserServiceError>
    func removeSnippet(_ snippet: Snippet) -> AnyPublisher<Void, SnippetsParserServiceError>
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
    
}
