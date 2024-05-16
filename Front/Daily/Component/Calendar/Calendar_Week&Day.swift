//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                WeekIndicator(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, tapPurpose: "change")
                CustomDivider(color: .primary, height: 2, hPadding: CGFloat.fontSize * 2)
                if calendarViewModel.recordsOnWeek.count > 0 {
                    ViewThatFits(in: .vertical) {
                        RecordList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                        ScrollView {
                            RecordList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                        }
                    }
                    .padding(.top, CGFloat.fontSize)
                    .padding(.bottom, CGFloat.fontSize * 15)
                    Spacer()
                    // swipeAction 고민
                } else {
                    NoRecord(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                }
            }
            .background(Color("ThemeColor"))
            if calendarViewModel.recordsOnWeek.count > 0 {
                AddGoalButton(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
            }
            WeeklySummary()
        }
    }
}
