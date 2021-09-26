//
//  DatabaseReference+Timeout.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 25/09/2021.
//

import FirebaseDatabase

extension DatabaseReference {

    func observe(
        _ eventType: DataEventType,
        timeout: TimeInterval,
        with block: @escaping (DataSnapshot?) -> Void
    ) -> UInt {
        var handle: UInt!

        let timer = Timer.scheduledTimer(
            withTimeInterval: timeout,
            repeats: false
        ) { _ in
            self.removeObserver(withHandle: handle)
            block(nil)
        }

        handle = observe(eventType) { snapshot in
            timer.invalidate()
            block(snapshot)
        }

        return handle
    }

}
