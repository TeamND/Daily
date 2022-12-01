//
//  WeekOnMonth.swift
//  Daily
//
//  Created by 최승용 on 2022/11/21.
//

import SwiftUI

struct WeekOnMonth: View {
    @StateObject var calendar: Calendar
    let rowIndex: Int
    var body: some View {
        HStack {
            ForEach (0..<7) { colIndex in
                let isToday = rowIndex == 1 && colIndex == 1
                Button {
                    calendar.setState(state: "Week&Day")
                } label: {
                    DayOnMonth()
                        .padding(4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.green, lineWidth: 2)
                                .opacity(isToday ? 1 : 0)
                        }
                        .accentColor(.black)
                }
            }
        }
    }
}
