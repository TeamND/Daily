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
    @State var updateVersion: Bool = false
    
    var body: some View {
        let startDayIndex = userInfo.startDayIndex()
        let lengthOfMonth = userInfo.lengthOfMonth()
        let dividerIndex = (lengthOfMonth + startDayIndex - 1) / 7
        VStack(spacing: 0) {
            WeekIndicator(userInfo: userInfo, calendarViewModel: CalendarViewModel())
            CustomDivider(color: .primary, height: 2, hPadding: 12)
            if updateVersion {
                TabView(selection: $calendarViewModel.tagIndex) {
                    Text("\(userInfo.currentMonth - 1)")
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("목표 확인")
                        }
                        .tag(0)
                    VStack(spacing: 0) {
                        ForEach (0..<6) { rowIndex in
                            WeekOnMonth(userInfo: userInfo, calendarViewModel: calendarViewModel, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth)
                            if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
                        }
                        Spacer()
                    }
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("목표 확인")
                        }
                        .tag(1)
                    Text("\(userInfo.currentMonth + 1)")
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("목표 확인")
                        }
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                .onChange(of: calendarViewModel.tagIndex) { tagIndex in
                    if tagIndex == 0 {
                        userInfo.changeCalendar(direction: "prev", calendarViewModel: calendarViewModel)
                        calendarViewModel.tagIndex = 1
                    }
                    if tagIndex == 2 {
                        userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel)
                        calendarViewModel.tagIndex = 1
                    }
                }
            } else {
                VStack(spacing: 0) {
                    ForEach (0..<6) { rowIndex in
                        WeekOnMonth(userInfo: userInfo, calendarViewModel: calendarViewModel, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth)
                        if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            getCalendarMonth(userID: String(userInfo.uid), month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)") { (data) in
                calendarViewModel.setDaysOnMonth(daysOnMonth: data.data)
            }
        }
        .onChange(of: userInfo.currentMonth) { month in
            getCalendarMonth(userID: String(userInfo.uid), month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)") { (data) in
                calendarViewModel.setDaysOnMonth(daysOnMonth: data.data)
            }
        }
    }
}
