//
//  WeekIndicator.swift
//  Daily
//
//  Created by seungyooooong on 4/26/25.
//

import SwiftUI

struct WeekIndicator: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @AppStorage(UserDefaultKey.startDay.rawValue) var startDay: Int = 0
    
    let mode: WeekIndicatorModes
    
    var body: some View {
        HStack(spacing: .zero) {
            Spacer()
            ForEach(.zero ..< GeneralServices.week, id: \.self) { index in
                let dayOfWeek = DayOfWeek.allCases[(index + startDay) % GeneralServices.week]
                let isNow = calendarViewModel.currentDate.weekday == dayOfWeek.index + 1
                Text(dayOfWeek.text)
                    .font(Fonts.bodySmRegular)
                    .foregroundStyle(mode == .change && isNow ? Colors.Text.point : Colors.Text.primary)
                Spacer()
            }
        }
        .frame(height: 16)
    }
}
