//
//  CalendarView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CalendarHeader(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
            if calendarViewModel.currentState == "year" { Calendar_Year(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel) }
            if calendarViewModel.currentState == "month" { Calendar_Month(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel) }
            if calendarViewModel.currentState == "week" { Calendar_Week_Day(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel) }
        }
    }
}

#Preview {
    CalendarView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
}
