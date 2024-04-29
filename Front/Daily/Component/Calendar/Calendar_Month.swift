//
//  Calendar_Month.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Month: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var isLoading: Bool = true
    @State var updateVersion: Bool = false
    @State var positionInViewPager = marginRange
    
    var body: some View {
        let startDayIndex = calendarViewModel.startDayIndex(userInfoViewModel: userInfoViewModel)
        let lengthOfMonth = calendarViewModel.lengthOfMonth()
        let dividerIndex = (lengthOfMonth + startDayIndex - 1) / 7
        ZStack {
            if updateVersion {
//                if isLoading {
//                    Text("Loading...")
//                } else {
                    VStack(spacing: 0) {
                        WeekIndicator(userInfoViewModel: userInfoViewModel, calendarViewModel: CalendarViewModel())
                        CustomDivider(color: .primary, height: 2, hPadding: 12)
                        ViewPager(position: $positionInViewPager) {
                            ForEach(calendarViewModel.getCurrentMonth() - marginRange ... calendarViewModel.getCurrentMonth() + marginRange, id: \.self) { month in
                                VStack(spacing: 0) {
                                    ForEach (0..<6) { rowIndex in
                                        WeekOnMonth(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth, updateVersion: updateVersion)
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
//                }
            } else {
                VStack(spacing: 0) {
                    WeekIndicator(userInfoViewModel: userInfoViewModel, calendarViewModel: CalendarViewModel())
                    CustomDivider(color: .primary, height: 2, hPadding: CGFloat.fontSize * 2)
                    VStack(spacing: 0) {
                        ForEach (0..<6) { rowIndex in
                            WeekOnMonth(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth, updateVersion: updateVersion)
                            if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
                        }
                        Spacer()
                    }
                }
                .background(Color("ThemeColor"))
            }
            AddGoalButton(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, updateVersion: updateVersion)
        }
    }
}
