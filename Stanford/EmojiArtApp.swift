//
//  EmojiArtApp.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 02/07/22.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocumentViewModel()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
