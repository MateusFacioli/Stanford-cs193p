//
//  StanfordApp.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 02/07/22.
//

import SwiftUI

@main
struct StanfordApp: App {
    let game = EmojiMemoryGameViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
