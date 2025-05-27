//
//  RatingIndicator.swift
//  Daily
//
//  Created by seungyooooong on 4/28/25.
//

import SwiftUI

@available(iOS 13.0, *)
public struct RatingIndicator: View {
    public let rating: Double
    public let lineWidth: CGFloat
    
    public init(rating: Double, lineWidth: CGFloat = 2.5) {
        self.rating = rating
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(Colors.Border.primary, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            Circle()
                .trim(from: 1 - rating, to: 1)
                .stroke(Colors.Icon.interactivePressed,style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
        }
        .animation(.easeInOut(duration: 0.5), value: rating)
    }
}
