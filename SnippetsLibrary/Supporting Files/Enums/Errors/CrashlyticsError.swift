//
//  CrashlyticsError.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 17/09/2021.
//

import Foundation

enum CrashlyticsErrorType: String {
    case unableToCreateSnippet
    case unableToUpdateSnippet
    case unableToRemoveSnippet
    case unableToCreateSnippetFromDroppedFile
}
