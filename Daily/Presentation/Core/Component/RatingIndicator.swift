//
//  RatingIndicator.swift
//  Daily
//
//  Created by seungyooooong on 4/28/25.
//

import SwiftUI

struct RatingIndicator: View {
    let rating: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Colors.Border.primary, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
            Circle()
                .trim(from: 1 - rating, to: 1)
                .stroke(Colors.Icon.interactivePressed,style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
        }
        .animation(.easeInOut(duration: 0.5), value: rating)
    }
}
