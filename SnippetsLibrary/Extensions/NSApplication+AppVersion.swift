//
//  NSApplication+AppVersion.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 07/09/2021.
//

import SwiftUI

extension NSApplication {
    
    static var appVersion: String {
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        
        let formattedBuildNumber = buildNumber.map {
            return "(\($0))"
        }

        return [versionNumber,formattedBuildNumber].compactMap { $0 }.joined(separator: " ")
    }
    
}
