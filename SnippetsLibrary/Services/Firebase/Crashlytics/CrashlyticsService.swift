//
//  CrashlyticsService.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 17/09/2021.
//

import Firebase

protocol CrashlyticsService {
    func logNonFatalError(_ type: CrashlyticsErrorType)
    func logError(withMessage message: String)
}

final class CrashlyticsServiceImpl: CrashlyticsService {
    
    // MARK: - Initialization
    
    init() {
        Crashlytics.crashlytics().setUserID(System.getHardwareUUID())
    }
    
    // MARK: - Methods
    
    internal func logNonFatalError(_ type: CrashlyticsErrorType) {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Non-fatal error reported.", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("\(type.rawValue)", comment: "")
        ]
        
        let error = NSError(
            domain: NSCocoaErrorDomain,
            code: -1001,
            userInfo: userInfo
        )
        Crashlytics.crashlytics().record(error: error)
    }
    
    internal func logError(withMessage message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
}
