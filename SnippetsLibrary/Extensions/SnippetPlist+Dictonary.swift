//
//  SnippetPlist+Dictonary.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 19/09/2021.
//

import Foundation

extension SnippetPlist {
    
    func convertedToDictonary(id: String? = nil) -> [String: Any] {
        return [
            "IDECodeSnippetIdentifier": id ?? self.id,
            "IDECodeSnippetTitle": title,
            "IDECodeSnippetSummary": summary,
            "IDECodeSnippetCompletionPrefix": completion,
            "IDECodeSnippetCompletionScopes": availability,
            "IDECodeSnippetContents": contents,
            "IDECodeSnippetLanguage": language,
            "IDECodeSnippetPlatformFamily": platform,
            "IDECodeSnippetUserSnippet": userSnippet,
            "IDECodeSnippetVersion": version,
            "IDECodeSnippetAuthor": author ?? "Christopher Lowiec"
        ] as [String: Any]
    }
    
}
