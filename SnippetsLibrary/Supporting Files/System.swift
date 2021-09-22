//
//  System.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 17/09/2021.
//

import Foundation

public struct System {
    
    static func getHardwareUUID() -> String {
        let matchingDict = IOServiceMatching("IOPlatformExpertDevice")
        let platformExpert = IOServiceGetMatchingService(
            kIOMasterPortDefault,
            matchingDict
        )
        
        defer { IOObjectRelease(platformExpert) }
        
        guard platformExpert != .zero else { return "" }
        
        return IORegistryEntryCreateCFProperty(
            platformExpert, kIOPlatformUUIDKey as CFString,
            kCFAllocatorDefault,
            .zero
        ).takeRetainedValue() as? String ?? ""
    }
    
}
