//
//  WeekOnMonth.swift
//  Daily
//
//  Created by 최승용 on 2022/11/21.
//

import SwiftUI

struct WeekOnMonth: View {
    @StateObject var userInfo: UserInfo
    let rowIndex: Int
    let startDayIndex: Int
    let lengthOfMonth: Int
    var body: some View {
        HStack {
            ForEach (0..<7) { colIndex in
                let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
                if 1 <= day && day <= lengthOfMonth {
                    Button {
                        withAnimation {
                            userInfo.currentDay = day
                            userInfo.currentState = "week"
                        }
                    } label: {
                        DayOnMonth(day: day)
                            .padding(4)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.green, lineWidth: 2)
                                    .opacity(userInfo.isToday(day: day) ? 1 : 0)
                            }
                            .accentColor(.black)
                    }
                } else {
                    DayOnMonth(day: day)
                        .padding(4)
                        .opacity(0)
                }
            }
        }
    }
}
