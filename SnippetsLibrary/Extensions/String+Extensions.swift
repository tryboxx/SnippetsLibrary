//
//  String+Extensions.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/10/2021.
//

import Foundation

extension String {
    
    func numberOfLines() -> Int {
        return numberOfOccurrencesOf(string: "\n") + 1
    }

    func numberOfOccurrencesOf(string: String) -> Int {
        return components(separatedBy: string).count - 1
    }
    
}
