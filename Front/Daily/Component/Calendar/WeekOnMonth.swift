//
//  WeekOnMonth.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import SwiftUI

struct WeekOnMonth: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    let rowIndex: Int
    let startDayIndex: Int
    let lengthOfMonth: Int
    var body: some View {
        HStack(spacing: 0) {
            ForEach (0..<7) { colIndex in
                let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
                if 1 <= day && day <= lengthOfMonth {
                    Button {
                        withAnimation {
                            userInfo.currentDay = day
                            userInfo.currentState = "week"
                        }
                    } label: {
                        DayOnMonth(userInfo: userInfo, day: day, dayOnMonth: calendarViewModel.getDaysOnMonth(dayIndex: day-1))
                    }
                } else {
                    DayOnMonth(userInfo: userInfo, day: 0, dayOnMonth: dayOnMonthModel())
                        .opacity(0)
                }
            }
        }
    }
}
