//
//  MonthOnYear.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import SwiftUI

struct MonthOnYear: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    var month: Int

    var body: some View {
        let startDayIndex = userInfo.startDayIndex(month: month)
        let lengthOfMonth = userInfo.lengthOfMonth(month: month)
        VStack(alignment: .leading) {
            Text(userInfo.months[month - 1])
                .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                .foregroundColor(.primary)
                .padding(4)
            ForEach (0..<6) { rowIndex in
                HStack(spacing: 1) {
                    ForEach (0..<7) { colIndex in
                        ZStack {
                            let day: Int = rowIndex * 7 + colIndex - startDayIndex + 1
                            if 1 <= day && day <= lengthOfMonth {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: CGFloat.fontSize * 2))
                                    .foregroundColor(Color("CustomColor").opacity(calendarViewModel.getDayOfRatingOnYear(monthIndex: month-1, dayIndex: day-1)*0.8))
                                Text("\(day)")
                                    .font(.system(size: CGFloat.fontSize, weight: .bold))
                                    .foregroundColor(.primary)
                            } else {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: CGFloat.fontSize * 2))
                                    .foregroundColor(Color("CustomColor").opacity(0))
                                    .opacity(0)
                                Text("1")
                                    .font(.system(size: CGFloat.fontSize, weight: .bold))
                                    .opacity(0)
                            }
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(width: CGFloat.monthOnYearWidth, height: CGFloat.monthOnYearHeight)
    }
}
