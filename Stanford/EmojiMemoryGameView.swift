//
//  EmojiMemoryGameView.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 02/07/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGameViewModel // hear the scream of changes and rebuild the entire body could be named to game
    var body: some View {
        
        //MARK: FIRST APROACH
//        ScrollView {
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
//                ForEach(viewModel.cards) { card in
                // clousure syntax  in the end  could be removed
//                    CardView(card: card).aspectRatio(2/3, contentMode: .fit)
//                        .onTapGesture {
//                            viewModel.choose(card)
//                        }
//                }
//    MARK: second aproach
        AspectVGrid(items: viewModel.cards, aspectRatio: 2/3, content: { card in
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        })
        .foregroundColor(.red)
        .padding(.horizontal)
    }
}

struct CardView: View {
    let card: EmojiMemoryGameViewModel.Card
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                    .padding(4).opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360: 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
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
//        return EmojiMemoryGameView(viewModel: game)
        EmojiMemoryGameView(viewModel: game)
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
 
