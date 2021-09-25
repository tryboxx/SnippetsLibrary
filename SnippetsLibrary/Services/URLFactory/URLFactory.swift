//
//  URLFactory.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 23/09/2021.
//

import Foundation

protocol URLFactory {
    func getURL(withType type: URLType) -> URL?
}

final class URLFactoryImpl: URLFactory {
    
    private enum Constants {
        static let userGuidesUrlString = "https://github.com/tryboxx/SnippetsLibrary/blob/main/README.md"
        static let developerDocumentationUrlString = "https://github.com/tryboxx/SnippetsLibrary/wiki"
    }
    
    // MARK: - Methods
    
    internal func getURL(withType type: URLType) -> URL? {
        switch type {
        case .userGuides:
            return URL(string: Constants.userGuidesUrlString)
        case .docs:
            return URL(string: Constants.developerDocumentationUrlString)
        }
    }
    
}
