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
    @State var isLoading: Bool = true
    @State var updateVersion: Bool = false
    @State var positionInViewPager = marginRange
    
    var body: some View {
        let startDayIndex = userInfo.startDayIndex()
        let lengthOfMonth = userInfo.lengthOfMonth()
        let dividerIndex = (lengthOfMonth + startDayIndex - 1) / 7
        ZStack {
            if updateVersion {
                if isLoading {
                    Text("Loading...")
                } else {
                    VStack(spacing: 0) {
                        WeekIndicator(userInfo: userInfo, calendarViewModel: CalendarViewModel())
                        CustomDivider(color: .primary, height: 2, hPadding: 12)
                        ViewPager(position: $positionInViewPager) {
                            ForEach(calendarViewModel.currentMonth - marginRange ... calendarViewModel.currentMonth + marginRange, id: \.self) { month in
                                VStack(spacing: 0) {
                                    ForEach (0..<6) { rowIndex in
                                        WeekOnMonth(userInfo: userInfo, calendarViewModel: calendarViewModel, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth, updateVersion: updateVersion)
                                        if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
                                    }
                                    Spacer()
                                }
                                .background(Color("ThemeColor"))
                            }
                        }
                    }
                    .onChange(of: positionInViewPager) { newValue in
                        print(newValue)
                        if 0 < newValue && newValue < marginRange * 2 {
                            return
                        } else {
                            calendarViewModel.setCurrentMonth(month: calendarViewModel.getCurrentMonth() + newValue - marginRange)
                            positionInViewPager = marginRange
                        }
                    }
                    .animation(.spring, value: positionInViewPager)
                }
            } else {
                VStack(spacing: 0) {
                    WeekIndicator(userInfo: userInfo, calendarViewModel: CalendarViewModel())
                    CustomDivider(color: .primary, height: 2, hPadding: 12)
                    VStack(spacing: 0) {
                        ForEach (0..<6) { rowIndex in
                            WeekOnMonth(userInfo: userInfo, calendarViewModel: calendarViewModel, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth, updateVersion: updateVersion)
                            if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
                        }
                        Spacer()
                    }
                }
                .background(Color("ThemeColor"))
            }
            AddGoalButton(userInfo: userInfo, navigationViewModel: NavigationViewModel(), updateVersion: updateVersion)
        }
        .onAppear {
            getCalendarMonth(userID: String(userInfo.uid), month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)") { (data) in
                calendarViewModel.setDaysOnMonth(daysOnMonth: data.data)
                self.isLoading = false
            }
        }
        .onChange(of: userInfo.currentMonth) { month in
            getCalendarMonth(userID: String(userInfo.uid), month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)") { (data) in
                calendarViewModel.setDaysOnMonth(daysOnMonth: data.data)
            }
        }
    }
}
