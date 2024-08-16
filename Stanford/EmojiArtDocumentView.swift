//
//  EmojiArtDocumentView.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 02/07/22.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    @ObservedObject var document: EmojiArtDocumentViewModel
    let testEmojis = "😀😃🥹🐯🐸🐒🏀🥍🥊🚗🏎️🛻⌚️🖥️🗜️✝️✡️🛐🏴‍☠️🇮🇴🇧🇪🍏🌽🍉"
    let defaultEmojiFontSize: CGFloat = 40
    
    //MARK: MAIN
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            pallete
        }
    }
    
    //MARK: COMPONENTS
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.red
                ForEach(document.emojis) { emoji in
                    Text(emoji.text)
                        .font(.system(size: fontSize(for: emoji)))
                        .position(position(for: emoji, in: geometry))
                }
            }
            .onDrop(of:[.plainText] , isTargeted: nil ) { providers, location in
                 drop(providers: providers, at: location, in: geometry)
            }
        }
    }
    
    
    var pallete: some View {
        ScrollingEmojiView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    //MARK: FUNCTIONS
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        return providers.loadObjects(ofType: String.self) { string in
            if let emoji = string.first, emoji.isEmoji {
                document.addEmoji(
                    String(emoji),
                    at: convertToEmojiCoordinates(location, in: geometry),
                    size: defaultEmojiFontSize)
            }
        }
    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x),
            y: center.y + CGFloat(location.y)
        )
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint( x: location.x - center.x,
                                y: location.y - center.y
        )
        return(Int(location.x), Int(location.y))
    }
    
}

struct ScrollingEmojiView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag{ NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}










struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocumentViewModel())
    }
}
