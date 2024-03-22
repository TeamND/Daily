//
//  WeekOnMonth.swift
//  Daily
//
//  Created by 최승용 on 2022/11/21.
//

import SwiftUI

struct WeekOnMonth: View {
    @StateObject var userInfo: UserInfo
    @Binding var days: [[String: Any]]
    let rowIndex: Int
    let startDayIndex: Int
    let lengthOfMonth: Int
    var body: some View {
        HStack(spacing: 0) {
            ForEach (0..<7) { colIndex in
                let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
                if 1 <= day && day <= lengthOfMonth {
                    Button {
                        withAnimation {
                            userInfo.currentDay = day
                            userInfo.currentState = "week"
                        }
                    } label: {
                        DayOnMonth(userInfo: userInfo, day: day, dayObject: $days[day + startDayIndex - 1])
                    }
                } else {
                    DayOnMonth(userInfo: userInfo, day: 0, dayObject: $days[day + startDayIndex - 1])
                        .opacity(0)
                }
            }
        }
    }
}
