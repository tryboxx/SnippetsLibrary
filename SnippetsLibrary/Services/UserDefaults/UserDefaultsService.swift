//
//  UserDefaultsService.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 19/09/2021.
//

import Foundation
import Combine

protocol UserDefaultsService {
    func saveRecentSnippet(_ snippet: Snippet)
    func fetchRecentSnippets() -> AnyPublisher<[Snippet], Never>
}

final class UserDefaultsServiceImpl: UserDefaultsService {
    
    private enum Constants {
        static let recentSnippetKey = "RecentSnippet"
    }
    
    // MARK: - Stored Properties
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Methods
    
    internal func saveRecentSnippet(_ snippet: Snippet) {
        let snippet = SnippetPlist(from: snippet)
        let snippetDictonary = snippet.convertedToDictonary()
        
        userDefaults.set(
            snippetDictonary,
            forKey: Constants.recentSnippetKey + " \(snippet.id)"
        )
    }
    
    internal func fetchRecentSnippets() -> AnyPublisher<[Snippet], Never> {
        let keys = userDefaults.dictionaryRepresentation().keys.filter { $0.contains(Constants.recentSnippetKey) }
        
        return Future<[Snippet], Never> { [weak self] promise in
            var snippets = [Snippet]()
            
            for key in keys {
                guard
                    let snippetDictonary = self?.userDefaults.object(forKey: key),
                    let data = try? JSONSerialization.data(withJSONObject: snippetDictonary, options: []),
                    let snippet = try? JSONDecoder().decode(SnippetPlist.self, from: data)
                else { continue }
                
                snippets.append(Snippet(from: snippet))
            }
            
            promise(.success(snippets))
        }
        .eraseToAnyPublisher()
    }
    
}
