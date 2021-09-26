//
//  DatabaseService.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 15/09/2021.
//

import FirebaseDatabase
import Combine

protocol DatabaseService {
    func saveSnippet(_ snippet: SnippetPlist) -> AnyPublisher<Void, DatabaseError>
    func fetchSnippets() -> AnyPublisher<[Snippet], DatabaseError>
    func updateSnippet(_ snippet: Snippet) -> AnyPublisher<Void, DatabaseError>
    func removeSnippet(_ snippet: Snippet) -> AnyPublisher<Void, DatabaseError>
}

final class DatabaseServiceImpl: DatabaseService {
    
    // MARK: - Stored Properties
    
    private let ref = Database.database().reference()
    private let logsService: LogsService
    private let crashlyticsService: CrashlyticsService
    
    // MARK: - Initialization
    
    init(
        logsService: LogsService,
        crashlyticsService: CrashlyticsService
    ) {
        self.logsService = logsService
        self.crashlyticsService = crashlyticsService
    }
    
    // MARK: - Methods
    
    internal func saveSnippet(_ snippet: SnippetPlist) -> AnyPublisher<Void, DatabaseError> {
        guard let childKey = ref.child("snippets").childByAutoId().key else {
            return Fail(error: .unableToRetrieveKeyForChild)
                .eraseToAnyPublisher()
        }
        
        return Future<Void, DatabaseError> { [weak self] promise in
            let values = snippet.convertedToDictonary(id: childKey)
            
            self?.ref.child("snippets").child(childKey).setValue(values) { (error, _) in
                guard error == nil else {
                    self?.crashlyticsService.logNonFatalError(.unableToCreateSnippet)
                    promise(.failure(.unableToSaveSnippet))
                    return
                }
                
                self?.logsService.logUserActivity(type: .userSavedSnippet(childKey))
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    internal func fetchSnippets() -> AnyPublisher<[Snippet], DatabaseError> {
        return Future<[Snippet], DatabaseError> { [weak self] promise in
            _ = self?.ref.child("snippets").observe(.value, timeout: 5) {
                guard let snapshot = $0 else {
                    promise(.failure(.unableToFetchData))
                    return
                }
                
                guard let results = snapshot.value as? NSDictionary else {
                    promise(.failure(.unableToFetchData))
                    return
                }
                
                var snippets: [Snippet] = []
                
                for (_, value) in results {
                    guard let values = value as? NSDictionary else {
                        promise(.failure(.unableToFetchData))
                        return
                    }
                    
                    if let data = try? JSONSerialization.data(withJSONObject: values, options: []),
                       let snippet = try? JSONDecoder().decode(SnippetPlist.self, from: data) {
                        snippets.append(Snippet(from: snippet))
                    } else {
                        promise(.failure(.unableToDecodeSnippet))
                    }
                }
                
                promise(.success(snippets))
            }
        }
        .eraseToAnyPublisher()
    }
    
    internal func updateSnippet(_ snippet: Snippet) -> AnyPublisher<Void, DatabaseError> {
        let snippet = SnippetPlist(from: snippet)
        let values = snippet.convertedToDictonary()
        
        return Future<Void, DatabaseError> { [weak self] promise in
            self?.ref.child("snippets").child(snippet.id).updateChildValues(values) { (error, _) in
                guard error == nil else {
                    self?.crashlyticsService.logNonFatalError(.unableToUpdateSnippet)
                    promise(.failure(.unableToUpdateSnippet))
                    return
                }
                
                self?.logsService.logUserActivity(type: .userUpdatedSnippet(snippet.id))
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    internal func removeSnippet(_ snippet: Snippet) -> AnyPublisher<Void, DatabaseError> {
        return Future<Void, DatabaseError> { [weak self] promise in
            self?.ref.child("snippets").child(snippet.id).removeValue() { (error, _) in
                guard error == nil else {
                    self?.crashlyticsService.logNonFatalError(.unableToRemoveSnippet)
                    promise(.failure(.unableToRemoveSnippet))
                    return
                }
                
                self?.logsService.logUserActivity(type: .userRemovedSnippet(snippet.id))
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
