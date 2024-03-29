//
//  Calendar_Month.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Month: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    var body: some View {
        let startDayIndex = userInfo.startDayIndex()
        let lengthOfMonth = userInfo.lengthOfMonth()
        let dividerIndex = (lengthOfMonth + startDayIndex - 1) / 7
        VStack {
            WeekIndicator(userInfo: userInfo, calendarViewModel: CalendarViewModel())
            CustomDivider(color: .primary, height: 2, hPadding: 12)
            VStack(spacing: 0) {
                ForEach (0..<6) { rowIndex in
                    WeekOnMonth(userInfo: userInfo, calendarViewModel: calendarViewModel, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth)
                    if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
                }
                Spacer()
            }
        }
        .onAppear {
            getCalendarMonth(userID: String(userInfo.uid), month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)") { (data) in
                calendarViewModel.setDaysOnmonth(daysOnMonth: data.data)
            }
        }
        .onChange(of: userInfo.currentMonth) { month in
            getCalendarMonth(userID: String(userInfo.uid), month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)") { (data) in
                calendarViewModel.setDaysOnmonth(daysOnMonth: data.data)
            }
        }
    }
}
