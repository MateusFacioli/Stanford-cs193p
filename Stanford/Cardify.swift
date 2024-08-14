//
//  Cardify.swift
//  Stanford
//
//  Created by Mateus Rodrigues on 04/09/22.
//

import SwiftUI
struct Cardify: AnimatableModifier {
   
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double { //rename and give rotation
        get { rotation }
        set{ rotation = newValue }
    }
    
    var rotation: Double //in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape =  RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 { //0-90 front 90-180 back
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        //MARK: IMPLICIT ANIMATION
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    //MARK: resolving magic numbers
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isfaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isfaceUp))
    }
}
