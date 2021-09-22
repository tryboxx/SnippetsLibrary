//
//  LogsService.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 17/09/2021.
//

import Foundation
import FirebaseDatabase

protocol LogsService {
    func logUserActivity(type: UserActivityLogType)
}

final class LogsServiceImpl: LogsService {
    
    // MARK: - Stored Properties
    
    private let ref = Database.database().reference()
    
    // MARK: - Methods
    
    internal func logUserActivity(type: UserActivityLogType) {
        let values: [String: Any] = [
            "userDeviceUUID": System.getHardwareUUID(),
            "actionDescription": type.title,
            "date": Date().description(with: Locale.current),
            "level": type.level.rawValue
        ]
        #if RELEASE
        ref.child("usersActivityLog").childByAutoId().setValue(values)
        #else
        ref.child("developersActivityLog").childByAutoId().setValue(values)
        #endif
    }
    
}
