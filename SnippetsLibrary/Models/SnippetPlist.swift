//
//  SnippetPlist.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/09/2021.
//

import Foundation

struct SnippetPlist: Codable {
    
    var id: String
    var title: String
    var summary: String
    var contents: String
    var author: String?
    var language: String
    var completion: String
    var platform: String
    var availability: [String]
    var userSnippet: Bool
    var version: Int
    
    init(from snippet: Snippet, withId id: String? = nil) {
        self.id = id ?? snippet.id
        title = snippet.title
        summary = snippet.summary
        contents = snippet.content
        author = snippet.author
        completion = snippet.completion
        platform = snippet.platform.rawValue
        availability = [snippet.availability.string]
        language = "Xcode.SourceCodeLanguage.Swift"
        userSnippet = true
        version = 2
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PlistCodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        summary = try values.decode(String.self, forKey: .summary)
        contents = try values.decode(String.self, forKey: .contents)
        author = try values.decode(String.self, forKey: .author)
        completion = try values.decode(String.self, forKey: .completion)
        language = try values.decode(String.self, forKey: .language)
        userSnippet = try values.decode(Bool.self, forKey: .userSnippet)
        version = try values.decode(Int.self, forKey: .version)
        
        let platformName = try values.decode(String.self, forKey: .platform)
        platform = SnippetPlatform.allCases.first { $0.rawValue == platformName }?.rawValue ?? SnippetPlatform.all.rawValue
        
        let availabilityKey = try values.decode([String].self, forKey: .availability)
        availability = [SnippetAvailability.allCases.first { $0.string == availabilityKey.first }?.string ?? SnippetAvailability.allScopes.string]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PlistCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(summary, forKey: .summary)
        try container.encode(contents, forKey: .contents)
        try container.encode(author, forKey: .author)
        try container.encode(completion, forKey: .completion)
        try container.encode(platform, forKey: .platform)
        try container.encode(availability, forKey: .availability)
        try container.encode(language, forKey: .language)
        try container.encode(userSnippet, forKey: .userSnippet)
        try container.encode(version, forKey: .version)
    }
    
}
