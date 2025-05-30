//
//  DayIndicator.swift
//  Daily
//
//  Created by seungyooooong on 4/28/25.
//

import SwiftUI

@available(iOS 15.0, *)
public struct DayIndicator: View {
    public let day: Int
    public let rating: Double?
    public let isToday: Bool
    public let isNow: Bool
    
    public init(day: Int, rating: Double?, isToday: Bool, isNow: Bool = false) {
        self.day = day
        self.rating = rating
        self.isToday = isToday
        self.isNow = isNow
    }
    
    public var body: some View {
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
