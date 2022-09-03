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
                let shape =  RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                        .padding(4).opacity(0.5)
                    Text(card.content).font(Font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        }
    }
    private func Font(in size: CGSize) -> Font {
        SwiftUI.Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    //MARK: resolving magic numbers
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        
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
