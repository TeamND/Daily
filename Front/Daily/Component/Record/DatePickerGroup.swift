//
//  DatePickerGroup.swift
//  Daily
//
//  Created by 최승용 on 4/11/24.
//

import SwiftUI

struct DatePickerGroup: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var date: Date
    @State var isShowCalendarSheet: Bool = false
    
    var body: some View {
        Group {
            Label {
                Text("\(calendarViewModel.getCurrentYearLabel(userInfoViewModel: userInfoViewModel)) \(calendarViewModel.getCurrentMonthLabel(userInfoViewModel: userInfoViewModel)) \(calendarViewModel.getCurrentDayLabel(userInfoViewModel: userInfoViewModel)) \(calendarViewModel.getCurrentDOW(userInfoViewModel: userInfoViewModel))요일")
            } icon: {
                Image(systemName: "calendar")
            }
        }
        .onTapGesture {
            isShowCalendarSheet = true
        }
        .sheet(isPresented: $isShowCalendarSheet) {
            CalendarSheet(calendarViewModel: calendarViewModel, date: $date)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
