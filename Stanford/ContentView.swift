//
//  ContentView.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 02/07/22.
//

import SwiftUI

struct ContentView: View {
    var emojis = ["✈️", "🚢", "🚁", "🚘", "🛺", "🏎", "🚑", "🚟", "🚀", "🛴", "🚲", "🛵", "🏍", "🚂", "⛵️", "🚤"]
    @State var emojiCount = 3
    var body: some View {
        VStack {
            HStack {
                ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                    CardView(content: emoji)
                }
            }
            Button(action: {}, label: {Text("Add card")})
        }
        .padding(.horizontal)
        .foregroundColor(.red)
    }
}

struct CardView: View {
    @State var isFaceUp: Bool = true
    var content: String
    var body: some View {
        ZStack {
            let shape =  RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
               shape.fill().foregroundColor(.white)
               shape.stroke(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
               shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
