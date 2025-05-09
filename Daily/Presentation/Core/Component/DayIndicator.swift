//
//  DayIndicator.swift
//  Daily
//
//  Created by seungyooooong on 4/28/25.
//

import SwiftUI

struct DayIndicator: View {
    private let day: Int
    private let rating: Double?
    private let isToday: Bool
    private let isNow: Bool
    
    init(day: Int, rating: Double?, isToday: Bool, isNow: Bool = false) {
        self.day = day
        self.rating = rating
        self.isToday = isToday
        self.isNow = isNow
    }
    
    var body: some View {
        ZStack {
            // MARK: UI 디테일을 위한 padding 포함
            if let rating { RatingIndicator(rating: rating).padding(1) }
            if isToday { Circle().fill(Colors.Icon.interactivePressed).padding(2) }
            Text(String(day))
                .font(Fonts.bodyMdSemiBold)
                .foregroundStyle(isToday ? Colors.Text.inverse : isNow ? Colors.Text.point : Colors.Text.secondary)
        }
        .frame(width: 33, height: 33)
    }
}
