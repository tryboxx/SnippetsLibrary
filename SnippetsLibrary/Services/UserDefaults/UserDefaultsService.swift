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
    func fetchSnippets(fetchingType: SnippetsFetchingType) -> AnyPublisher<[Snippet], Never>
    func saveSnippetsLocally(_ snippets: [Snippet])
    
    func fetchRecentSnippetsFromAppGroup() -> [Snippet]
}

final class UserDefaultsServiceImpl: UserDefaultsService {
    
    private enum Constants {
        static let recentSnippetKey = "RecentSnippet"
        static let localSnippetKey = "LocalSnippet"
        static let appGroupName = "group.com.cphlowiec.SnippetsLibrary"
    }
    
    // MARK: - Stored Properties
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Methods
    
    // MARK: - Recent Snippets -
    
    internal func saveRecentSnippet(_ snippet: Snippet) {
        let snippet = SnippetPlist(from: snippet)
        let snippetDictonary = snippet.convertedToDictonary()
        let snippetKey = Constants.recentSnippetKey + " \(snippet.id)"
        
        userDefaults.set(
            snippetDictonary,
            forKey: snippetKey
        )
        
        saveSnippetDictonaryIntoAppGroup(
            snippetDictonary,
            key: snippetKey
        )
    }
    
    internal func fetchSnippets(fetchingType: SnippetsFetchingType) -> AnyPublisher<[Snippet], Never> {
        let fetchingKey = fetchingType == .recent ? Constants.recentSnippetKey : Constants.localSnippetKey
        let keys = userDefaults.dictionaryRepresentation().keys.filter { $0.contains(fetchingKey) }
        
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
    
    // MARK: - Local snippets -
    
    internal func saveSnippetsLocally(_ snippets: [Snippet]) {
        for snippet in snippets {
            saveSnippetLocally(snippet)
        }
    }
    
    private func saveSnippetLocally(_ snippet: Snippet) {
        let snippet = SnippetPlist(from: snippet)
        let snippetDictonary = snippet.convertedToDictonary()
        let snippetKey = Constants.localSnippetKey + " \(snippet.id)"
        
        userDefaults.set(
            snippetDictonary,
            forKey: snippetKey
        )
    }
    
    // MARK: - App Group -
    
    internal func fetchRecentSnippetsFromAppGroup() -> [Snippet] {
        guard let userDefaults = UserDefaults(suiteName: Constants.appGroupName) else { return [] }
        
        let keys = userDefaults.dictionaryRepresentation().keys.filter { $0.contains(Constants.recentSnippetKey) }
        var snippets = [Snippet]()
        
        for key in keys {
            guard
                let snippetDictonary = userDefaults.object(forKey: key),
                let data = try? JSONSerialization.data(withJSONObject: snippetDictonary, options: []),
                let snippet = try? JSONDecoder().decode(SnippetPlist.self, from: data)
            else { continue }
            
            snippets.append(Snippet(from: snippet))
        }
        
        return snippets
    }
    
    private func saveSnippetDictonaryIntoAppGroup(
        _ snippetDictonary: [String: Any],
        key: String
    ) {
        guard let userDefaults = UserDefaults(suiteName: Constants.appGroupName) else { return }
        
        userDefaults.set(
            snippetDictonary,
            forKey: key
        )
    }
    
}
