//
//  MemoryGameModel.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 13/07/22.
//

import Foundation

struct MemoryGameModel<CardContent> where CardContent: Equatable {
   private(set) var cards: Array<Card>// everyone see the cards but dont change it
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?//computed property
    {
        get {
//            MARK: second aproach
//            let faceUpCardIndices = cards.indices.filter {
//                 index in // -  param could be used
//                cards[index].isFaceUp
//              cards[$0].isFaceUp // - or using the $0
//            }//this closure replaces the code below
            
            //MARK: first aproach
//            var faceUpCardIndices = [Int]()
//            for index in faceUpCardIndices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }
//            return faceUpCardIndices.oneAndOnly
        
//          MARK: final aproach
             cards.indices.filter ({cards[$0].isFaceUp}).oneAndOnly
        }
        set {
//            for index in cards.indices {
//             MARK: second aproach
//                cards[index].isFaceUp = (index == newValue) // this line replaces the code below
            
//             MARK: first aproach
//                if index != newValue {
//                    cards[index].isFaceUp = false
//                } else {
//                    cards[index].isFaceUp = true
//                }
//            }
//            MARK: final aproach
            cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue) }
        }
    }
    
    mutating func choose(_ card: Card) {
//        if let chosenIndex = index(of: card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}), //function programming
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    //this function have been replaced by called in choose function
//    func index(of card: Card) -> Int? { //external and internal name of parameter
//        for index in 0..<cards.count {
//            if cards[index].id == card.id {
//                return index
//            }
//        }
//        return nil
//    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [] //Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: Int // it can be whatever you want
    }
}

extension  Array { // if have one element return it if have more return nil
    var oneAndOnly: Element? {
        if  count == 1 { //self.count == 1 {
           return first //return self.first
        } else {
            return nil
        }
    }
}
