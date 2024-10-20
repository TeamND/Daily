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
    @Binding var currentDate: Date
    @State var isShowCalendarSheet: Bool = false
    
    var body: some View {
        Group {
            Label {
                Text("\(String(currentDate.year)). \(String(format: "%02d", currentDate.month)). \(String(format: "%02d", currentDate.day)). \(currentDate.getDOW(language: userInfoViewModel.language))")
                    .font(.system(size: CGFloat.fontSize * 2.5))
            } icon: {
                Image(systemName: "calendar")
            }
        }
        .onTapGesture {
            isShowCalendarSheet = true
        }
        .sheet(isPresented: $isShowCalendarSheet) {
            CalendarSheet(calendarViewModel: calendarViewModel, currentDate: $currentDate)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
