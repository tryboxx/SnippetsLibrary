//
//  UploadingStatus.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 26/09/2021.
//

import Foundation

enum UploadingStatus {
    case initializing
    case uploading
    case done
    case error
    
    var currentDescription: String {
        switch self {
        case .initializing:
            return "Initializing..."
        case .uploading:
            return "Uploading code snippets into the Xcode..."
        default:
            return ""
        }
    }
    
    internal var title: String {
        switch self {
        case .uploading,
             .initializing:
            return "Uploading"
        case .done:
            return "Upload Successful"
        case .error:
            return "Upload Failed"
        }
    }
    
    internal var message: String {
        switch self {
        case .done: return "Please relaunch Xcode to see all uploaded code snippets."
        case .error: return "Unable to upload code snippets. Please try again later."
        default: return ""
        }
    }
}
