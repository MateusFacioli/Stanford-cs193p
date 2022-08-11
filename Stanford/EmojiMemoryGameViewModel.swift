//
//  EmojiMemoryGameViewModel.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 13/07/22.
//

import SwiftUI


class EmojiMemoryGameViewModel: ObservableObject { // scream that something has changed
private static let emojis = ["✈️", "🚢", "🚁", "🚘", "🛺", "🏎", "🚑", "🚟", "🚀", "🛴", "🚲", "🛵", "🏍", "🚂", "⛵️", "🚤"]
    // static = global
 typealias Card = MemoryGameModel<String>.Card
    private static func createMemoryGame()  -> MemoryGameModel<String> {
        MemoryGameModel<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model = createMemoryGame()
    //@published calls the objectWillChange.send()
        
    // full private access, need to access it some other way
    
    var cards: Array<Card> {
         model.cards
    }
    
    //MARK: - Intents
    
    func choose(_ card: Card) {
        model.choose(card)
    }
}
