//
//  Calendar_Year.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Year: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    var body: some View {
        VStack(spacing: 0) {
            CustomDivider(color: .primary, height: 2)
                .padding(12)
            ForEach (0..<4) { rowIndex in
                HStack(spacing: 0) {
                    ForEach (0..<3) { colIndex in
                        let month = (rowIndex * 3) + colIndex + 1
                        Button {
                            withAnimation {
                                userInfo.currentMonth = month
                                userInfo.currentState = "month"
                            }
                        } label: {
                            MonthOnYear(userInfo: userInfo, calendarViewModel: calendarViewModel, month: month)
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            getCalendarYear(userID: String(userInfo.uid), year: userInfo.currentYearStr) { (data) in
                calendarViewModel.setRatingOnYear(ratingOnYear: data.data)
            }
        }
        .onChange(of: userInfo.currentYear) { year in
            getCalendarYear(userID: String(userInfo.uid), year: userInfo.currentYearStr) { (data) in
                calendarViewModel.setRatingOnYear(ratingOnYear: data.data)
            }
        }
    }
}
