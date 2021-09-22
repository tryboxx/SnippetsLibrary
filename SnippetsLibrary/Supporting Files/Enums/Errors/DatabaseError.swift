//
//  DatabaseError.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 17/09/2021.
//

import Foundation

enum DatabaseError: Error {
    case unableToRetrieveKeyForChild
    case unableToSaveSnippet
    case unableToFetchData
    case unableToDecodeSnippet
    case unableToRemoveSnippet
    case unableToUpdateSnippet
}
