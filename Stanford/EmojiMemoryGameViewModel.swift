//
//  EmojiMemoryGameViewModel.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 13/07/22.
//

import SwiftUI


class EmojiMemoryGameViewModel: ObservableObject { // scream that something has changed
static let emojis = ["✈️", "🚢", "🚁", "🚘", "🛺", "🏎", "🚑", "🚟", "🚀", "🛴", "🚲", "🛵", "🏍", "🚂", "⛵️", "🚤"]
    // static = global

    static func createMemoryGame()  -> MemoryGameModel<String> {
        MemoryGameModel<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model: MemoryGameModel<String> = createMemoryGame()
    //@published calls the objectWillChange.send()
        
    // full private access, need to access it some other way
    
    var cards: Array<MemoryGameModel<String>.Card> {
         model.cards
    }
    
    //MARK: - Intents
    
    func choose(_ card: MemoryGameModel<String>.Card) {
        model.choose(card)
    }
}
