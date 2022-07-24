//
//  EmojiMemoryGameViewModel.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 13/07/22.
//

import SwiftUI


class EmojiMemoryGameViewModel {
static let emojis = ["✈️", "🚢", "🚁", "🚘", "🛺", "🏎", "🚑", "🚟", "🚀", "🛴", "🚲", "🛵", "🏍", "🚂", "⛵️", "🚤"]
    // static = global

    static func createMemoryGame()  -> MemoryGameModel<String> {
        MemoryGameModel<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    private var model: MemoryGameModel<String> = createMemoryGame()
        
    // full private access, need to access it some other way
    
    var card: Array<MemoryGameModel<String>.Card> {
        return model.cards
    }
}
