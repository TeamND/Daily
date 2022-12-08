//
//  WeekOnMonth.swift
//  Daily
//
//  Created by 최승용 on 2022/11/21.
//

import SwiftUI

struct WeekOnMonth: View {
    @StateObject var calendar: MyCalendar
    let rowIndex: Int
    var body: some View {
        HStack {
            ForEach (0..<7) { colIndex in
                Button {
                    calendar.day = rowIndex * 7 + colIndex
                    calendar.setState(state: "Week&Day")
                } label: {
                    DayOnMonth(rowIndex: rowIndex, colIndex: colIndex)
                        .padding(4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.green, lineWidth: 2)
                                .opacity(calendar.isToday(rowIndex: rowIndex, colIndex: colIndex) ? 1 : 0)
                        }
                        .accentColor(.black)
                }
            }
        }
    }
}
