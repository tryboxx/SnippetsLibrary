//
//  DependencyContainer.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/09/2021.
//

import Foundation

let DIContainer = DependencyContainer.shared

final class DependencyContainer {
    
    // MARK: - Services
    
    lazy var snippetsParserService: SnippetsParserService = SnippetsParserServiceImpl()
    lazy var urlFactory: URLFactory = URLFactoryImpl()
    lazy var networkServcie: NetworkService = NetworkServiceImpl()
    
    lazy var databaseService: DatabaseService = DatabaseServiceImpl(
        logsService: logsService,
        crashlyticsService: crashlyticsService
    )
    lazy var logsService: LogsService = LogsServiceImpl()
    lazy var crashlyticsService: CrashlyticsService = CrashlyticsServiceImpl()
    lazy var userDefaultsService: UserDefaultsService = UserDefaultsServiceImpl()
    
    // MARK: - Shared
    
    static let shared = DependencyContainer()
    
}
