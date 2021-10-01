//
//  Snippet.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import Foundation

typealias SnippetId = String

struct Snippet: Codable, Identifiable, Hashable {
    
    // MARK: - Stored Properties
    
    let id: SnippetId
    var title: String
    var summary: String
    var content: String
    var author: String
    var completion: String
    var platform: SnippetPlatform
    var availability: SnippetAvailability
    
    // MARK: - Computed Properties
    
    var type: SnippetType {
        title.contains("+") ? .extending : .snippets
    }
    
    var category: SnippetCategory {
        return SnippetCategory.allCases.first(where: { title.lowercased().contains($0.rawValue) }) ?? .helper
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id, title, summary, content, author, completion, platform, availability
    }
    
    // MARK: - Initialization
    
    init() {
        id = UUID().uuidString
        title = ""
        summary = ""
        content = ""
        author = ""
        completion = ""
        platform = .all
        availability = .allScopes
    }
    
    init(mockedForSkeleton: Bool) {
        id = UUID().uuidString
        title = "Default snippet title"
        summary = "Default snippet summary"
        content = ""
        author = ""
        completion = ""
        platform = .all
        availability = .allScopes
    }
    
    init(
        id: SnippetId,
        title: String,
        summary: String,
        content: String,
        author: String,
        completion: String,
        platform: SnippetPlatform,
        availability: SnippetAvailability
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.author = author
        self.completion = completion
        self.platform = platform
        self.availability = availability
    }
    
    init(from snippetPlist: SnippetPlist) {
        id = snippetPlist.id
        title = snippetPlist.title
        summary = snippetPlist.summary
        content = snippetPlist.contents
        author = snippetPlist.author ?? ""
        completion = snippetPlist.completion
        platform = SnippetPlatform.allCases.first(where: { $0.rawValue == snippetPlist.platform }) ?? SnippetPlatform.all
        availability = SnippetAvailability.allCases.first(where: { $0.string == snippetPlist.availability.first }) ?? SnippetAvailability.allScopes
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PlistCodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        summary = try values.decode(String.self, forKey: .summary)
        content = try values.decode(String.self, forKey: .contents)
        author = try values.decode(String.self, forKey: .author)
        completion = try values.decode(String.self, forKey: .completion)
        
        let platformName = try values.decode(String.self, forKey: .platform)
        platform = SnippetPlatform.allCases.first { $0.rawValue == platformName } ?? .all
        
        let availabilityName = try values.decode([String].self, forKey: .availability)
        availability = SnippetAvailability.allCases.first { $0.string == availabilityName.first } ?? .allScopes
    }
    
    // MARK: - Methods
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(summary, forKey: .summary)
        try container.encode(content, forKey: .content)
        try container.encode(author, forKey: .author)
        try container.encode(completion, forKey: .completion)
        try container.encode(platform.title, forKey: .platform)
        try container.encode(availability.title, forKey: .availability)
    }
    
}
