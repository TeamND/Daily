//
//  DatePickerGroup.swift
//  Daily
//
//  Created by 최승용 on 4/11/24.
//

import SwiftUI

struct DatePickerGroup: View {
    @ObservedObject var userInfo: UserInfo
    @Binding var date: Date
    @State var isShowCalendarSheet: Bool = false
    
    var body: some View {
        Group {
            Label {
                Text("\(userInfo.currentYearLabel) \(userInfo.currentMonthLabel) \(userInfo.currentDayLabel) \(userInfo.currentDOW)요일")
            } icon: {
                Image(systemName: "calendar")
            }
        }
        .onTapGesture {
            isShowCalendarSheet = true
        }
        .sheet(isPresented: $isShowCalendarSheet) {
            CalendarSheet(userInfo: userInfo, date: $date)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
