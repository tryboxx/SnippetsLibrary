//
//  PlistCodingKeys.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 13/09/2021.
//

import Foundation

enum PlistCodingKeys: String, CodingKey {
    case id = "IDECodeSnippetIdentifier"
    case title = "IDECodeSnippetTitle"
    case summary = "IDECodeSnippetSummary"
    case completion = "IDECodeSnippetCompletionPrefix"
    case availability = "IDECodeSnippetCompletionScopes"
    case contents = "IDECodeSnippetContents"
    case language = "IDECodeSnippetLanguage"
    case platform = "IDECodeSnippetPlatformFamily"
    case userSnippet = "IDECodeSnippetUserSnippet"
    case version = "IDECodeSnippetVersion"
    case author = "IDECodeSnippetAuthor"
    case tags = "IDECodeSnippetTags"
}
