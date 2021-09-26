//
//  Mocks.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 08/09/2021.
//

import Foundation

let mockedSnippets = [
    Snippet(
        id: UUID().uuidString,
        title: "AnyPublisher+Method",
        summary: "Easly create AnyPublisher method",
        content:
            """
                func <#method name#>() -> AnyPublisher<Void, Error> {
                    return Future<Void, Error> { promise in
                        do {
                            try <#throwing action#>
                            promise(.success(()))
                        } catch {
                            promise(.failure(<#Error#>))
                        }
                    }
                    .eraseToAnyPublisher()
                }
                """,
        author: "Christopher Lowiec",
        completion: "anypubmeth",
        platform: .iphoneos,
        availability: .topLevel
    )
]

let skeletonSnippets = [
    Snippet(mockedForSkeleton: true),
    Snippet(mockedForSkeleton: true),
    Snippet(mockedForSkeleton: true),
    Snippet(mockedForSkeleton: true),
    Snippet(mockedForSkeleton: true),
    Snippet(mockedForSkeleton: true)
]
