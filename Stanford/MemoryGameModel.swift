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
    //MARK: OLD FUNCTION -have been replaced by choose function 
//    func index(of card: Card) -> Int? { //external and internal name of parameter
//        for index in 0..<cards.count {
//            if cards[index].id == card.id {
//                return index
//            }
//        }
//        return nil
//    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [] //Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {//props observer
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        let id: Int // it can be whatever you want
        
        // MARK: - Bonus Time
        // if the user matches the card before a certain amount of time passes during which the card is face up

        
        var bonusTimeLimit: TimeInterval = 6// can be zero which means "no bonus available" for this card
        var lastFaceUpDate: Date?// the last time this card was turned face up (and is still face up)
        var pastFaceUpTime: TimeInterval = 0 // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        
        
        var bonusTimeRemaining: TimeInterval { // how much time left before the bonus opportunity runs out
            max(0, bonusTimeLimit - faceUpTime)
        }
       
        var bonusRemaining: Double { // percentage of the bonus time remaining
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
       
        var hasEarnedBonus: Bool {  // whether the card was matched during the bonus time period
            isMatched && bonusTimeRemaining > 0
        }
       
        var isConsumingBonusTime: Bool {  // whether we are currently face up, unmatched and have not yet used up the bonus window
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        
        private mutating func startUsingBonusTime() { // called when the card transitions to face up state
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() { // called when the card goes back face down (or gets matched)
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
        
    }
}

extension  Array { // if have one element return it if have more return nil
    var oneAndOnly: Element? {
        if  count == 1 {
           return first
        } else {
            return nil
        }
    }
}
