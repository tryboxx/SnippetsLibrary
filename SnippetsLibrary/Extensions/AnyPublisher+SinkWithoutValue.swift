//
//  AnyPublisher+SinkWithoutValue.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 12/09/2021.
//

import Combine

extension AnyPublisher where Self.Output == Void {
    
    func sink(receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: receiveCompletion) { _ in }
    }
    
}
