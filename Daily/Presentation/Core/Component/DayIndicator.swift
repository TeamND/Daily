//
//  DayIndicator.swift
//  Daily
//
//  Created by seungyooooong on 4/28/25.
//

import SwiftUI

struct DayIndicator: View {
    let day: Int
    let rating: Double?
    let isToday: Bool
    
    var body: some View {
        ZStack {
            if let rating { RatingIndicator(rating: rating) }
            if isToday { Circle().fill(Colors.Icon.interactivePressed).padding(1) }
            Text(String(day))
                .font(Fonts.bodyMdSemiBold)
                .foregroundStyle(isToday ? Colors.Text.inverse : Colors.Text.secondary)
        }
        .frame(width: 33, height: 33)
    }
}
