//
//  CalendarView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var navigationViewModel: NavigationViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CalendarHeader(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel)
            if userInfo.currentState == "year" { Calendar_Year(userInfo: userInfo, calendarViewModel: calendarViewModel) }
            if userInfo.currentState == "month" { Calendar_Month(userInfo: userInfo, calendarViewModel: calendarViewModel) }
            if userInfo.currentState == "week" { Calendar_Week_Day(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel) }
        }
    }
}

#Preview {
    CalendarView(userInfo: UserInfo(), userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel(), navigationViewModel: NavigationViewModel())
}
