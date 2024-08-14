//
//  EmojiMemoryGameView.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 02/07/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    //MARK: PROPERTIES
    @ObservedObject var GameViewModel: EmojiMemoryGameViewModel// see changes and rebuild the view
    @Namespace private var dealingNamespace
    @State private var dealt = Set<Int>()//unique var just to track the cards and insertion works
    
    //MARK: MAIN BODY VIEW
    var body: some View {
        ZStack(alignment: .bottom){
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    
    //MARK: FUNCTIONS
    private func deal(_ card: EmojiMemoryGameViewModel.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGameViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGameViewModel.Card) -> Animation {
        var delay = 0.0
        if let index = GameViewModel.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(GameViewModel.cards.count))
        }
        return Animation.easeOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGameViewModel.Card) -> Double {
        -Double(GameViewModel.cards.firstIndex(where: { $0.id == card.id}) ?? 0)
    }
    
    //MARK: COMPONENTS
    var gameBody: some View {
        //        MARK: FIRST APROACH
        //        ScrollView {
        //            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
        //                ForEach(GameViewModel.cards) { card in
        // clousure syntax  in the end  could be removed
        //                    CardView(card: card).aspectRatio(2/3, contentMode: .fit)
        //                        .onTapGesture {
        //                            GameViewModel.choose(card)
        //                        }
        //                }
        //    MARK: second aproach
        AspectVGrid(items: GameViewModel.cards, aspectRatio: 2/3, content: { card in
            if  isUndealt(card) || (card.isMatched && !card.isFaceUp) {// first way to appearing and disappering
                Color.clear// used like a view
                //Rectangle().opacity(0)// fill the space in the aspectVGrid
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                // identity = do not do any animation
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        //MARK: EXPLICIT ANIMATION
                        withAnimation(.easeInOut(duration: 0.5)) {
                            GameViewModel.choose(card)
                        }
                    }
            }
        })
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {// second way to appearing and disappering
        ZStack {
            ForEach(GameViewModel.cards.filter(isUndealt) /*{ isUndealt($0) }*/) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture { //vgrid came on screen with the cards already there
            //"deal" the cards out on UI
            for card in GameViewModel.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    //MARK: BUTTONS
    var shuffle: some View {
        Button("Shuffle") {
            //MARK: EXPLICIT ANIMATION
            withAnimation {
                GameViewModel.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            //MARK: EXPLICIT ANIMATION
            withAnimation {
                dealt = []
                GameViewModel.restart()
            }
        }
    }
    
    //MARK: CONSTANTS
    private struct CardConstants {
        static let color = Color.black
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2.0
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

//MARK: MODELS - STRUCTS
struct CardView: View {
    let card: EmojiMemoryGameViewModel.Card
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining) * 360 - 90))
                            .onAppear() {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining) * 360 - 90))
                    }
                }
                .padding(4)
                .opacity(0.5)
                Text(card.content)
                //MARK: IMPLICIT ANIMATION
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 * 3: 0))// somente quando match
                    .animation(Animation.linear(duration: 1))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            //.modifier(Cardify(isFaceUp: card.isFaceUp)) any view could be before of this line
            .cardify(isfaceUp: card.isFaceUp) // using the extension
        }
    }
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    //MARK: resolving magic numbers
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGameViewModel()
        //MARK: to test only
        //        game.choose(game.cards.first!)
        //        return EmojiMemoryGameView(GameViewModel: game)
        EmojiMemoryGameView(GameViewModel: game)
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(GameViewModel: game)
            .preferredColorScheme(.light)
    }
}

