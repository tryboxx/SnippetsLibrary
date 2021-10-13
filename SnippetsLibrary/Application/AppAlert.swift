//
//  AppAlert.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/10/2021.
//

import Foundation

enum AppAlert: Identifiable {
    case snippetDownload
    
    var id: Int {
        switch self {
        case .snippetDownload: return 0
        }
    }
}
