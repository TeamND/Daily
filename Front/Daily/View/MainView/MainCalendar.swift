//
//  MainCalendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainCalendar: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var navigationViewModel: NavigationViewModel
    var body: some View {
        if userInfo.currentState == "year" { Calendar_Year(userInfo: userInfo, calendarViewModel: calendarViewModel) }
        if userInfo.currentState == "month" { Calendar_Month(userInfo: userInfo, calendarViewModel: calendarViewModel) }
        if userInfo.currentState == "week" { Calendar_Week_Day(userInfo: userInfo, navigationViewModel: navigationViewModel, calendarViewModel: calendarViewModel) }
    }
}
