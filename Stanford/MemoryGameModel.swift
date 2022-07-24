//
//  MemoryGameModel.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 13/07/22.
//

import Foundation

struct MemoryGameModel<CardContent> {
   private(set) var cards: Array<Card>// everyone see the cards but dont change it
    
    func choose(_ card: Card) {
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    struct Card {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}
