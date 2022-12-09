//
//  Calendar_Year.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Year: View {
    @StateObject var calendar: MyCalendar
    var body: some View {
        VStack(spacing: 0) {
            CustomDivider(color: .black, height: 2)
                .padding(12)
            ForEach (0..<4) { rowIndex in
                HStack(spacing: 0) {
                    ForEach (0..<3) { colIndex in
                        let month = (rowIndex * 3) + colIndex + 1
                        Button {
                            calendar.month = month
                            calendar.setState(state: "Month")
                        } label: {
                            MonthOnYear(calendar: calendar, month: month)
                                .accentColor(.black)
                        }
                    }
                }
            }
            NavigationLink(
                destination: Calendar_Month(calendar: calendar)
                    .navigationBarTitle("\(calendar.month)월"),
                isActive: $calendar.showMonth,
                label: { EmptyView() }
            )
            Spacer()
        }
        .onAppear {
            calendar.setState(state: "Year")
        }
    }
}
