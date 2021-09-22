//
//  SnippetImportViewModel+DropDelegate.swift
//  SnippetsLibrary
//
//  Created by Krzysztof Łowiec on 13/09/2021.
//

import SwiftUI

extension SnippetImportViewModel: DropDelegate {
    
    func validateDrop(info: DropInfo) -> Bool {
        debugPrint("DropInfo: \(info)")
        return true
    }
    
    func performDrop(info: DropInfo) -> Bool {
        receiveDrop(
            dropIndex: .zero,
            itemProviders: info.itemProviders(for: [.fileURL])
        )
    }
    
    @discardableResult
    func receiveDrop(
        dropIndex: Int,
        itemProviders: [NSItemProvider],
        create: Bool = true
    ) -> Bool {
        var result = false
        for provider in itemProviders {
            if provider.canLoadObject(ofClass: String.self) {
                result = true
                loadSnippet(
                    from: provider,
                    at: dropIndex
                )
            }
        }
        return result
    }
    
    private func loadSnippet(
        from provider: NSItemProvider,
        at dropIndex: Int
    ) {
        provider.loadItem(forTypeIdentifier: kUTTypeFileURL as String) { [weak self] (data, error) in
            guard
                let safeData = data as? Data,
                let url = URL(dataRepresentation: safeData, relativeTo: nil)
            else {
                // Unable to load
                return
            }
            
            let decoder = PropertyListDecoder()
            
            guard
                let dataFromURL = try? Data(contentsOf: url),
                let snippet = try? decoder.decode(Snippet.self, from: dataFromURL)
            else {
                // Unable to load
                return
            }
            
            self?.createSnippet(snippet)
        }
    }
    
}
