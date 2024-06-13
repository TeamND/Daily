//
//  WeekOnMonth.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import SwiftUI

struct WeekOnMonth: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var userInfoViewModel: UserInfoViewModel
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
                        calendarViewModel.setCurrentState(state: "week", year: 0, month: 0, day: day, userInfoViewModel: userInfoViewModel) { code in
                            if code == "99" { alertViewModel.isShowAlert = true }
                        }
                    } label: {
                        DayOnMonth(calendarViewModel: calendarViewModel, day: day, dayOnMonth: calendarViewModel.getDaysOnMonth(dayIndex: day-1))
                    }
                } else {
                    DayOnMonth(calendarViewModel: calendarViewModel, day: 0, dayOnMonth: dayOnMonthModel())
                        .opacity(0)
                }
            }
        }
    }
}
