//
//  Calendar_Month.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Month: View {
    @StateObject var calendar: Calendar
    var body: some View {
        VStack {
            HStack {
                ForEach (kWeeks[0], id: \.self) { week in
                    Spacer()
                    Text(week)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 30)
            CustomDivider(color: .black, height: 2, hPadding: 12)
            VStack {
                ForEach (0..<6) { rowIndex in
                    Button {
                        calendar.setState(state: "Week&Day")
                    } label: {
                        WeekOnMonth(rowIndex: rowIndex)
                            .accentColor(.black)
                    }
                    if rowIndex < 5 { CustomDivider(hPadding: 20) }
                }
                Spacer()
            }
            
            NavigationLink(
                destination: Calendar_Week_Day()
                    .navigationBarTitle(dformat.string(from: Date())),
                isActive: $calendar.showWeekDay,
                label: { EmptyView() }
            )
        }
        .onAppear {
            calendar.setState(state: "Month")
        }
    }
}
