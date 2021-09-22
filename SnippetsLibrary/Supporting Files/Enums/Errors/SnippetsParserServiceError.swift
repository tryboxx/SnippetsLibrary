//
//  SnippetsParserServiceError.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 13/09/2021.
//

import Foundation

enum SnippetsParserServiceError: Error {
    case unableToFindSnippetsDirectory
    case unableToSaveSnippet
    case unableToDecodeSnippet
    case unableToCreateDirectory
    case unableToRemoveSnippet
}
