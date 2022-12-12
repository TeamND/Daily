//
//  Calendar_Month.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Month: View {
    @StateObject var calendar: MyCalendar
    var body: some View {
        let startDayIndex = calendar.startDayIndex()
        let lengthOfMonth = calendar.lengthOfMonth()
        let dividerIndex = (lengthOfMonth + startDayIndex - 1) / 7
        VStack {
            WeekIndicator(calendar: calendar)
            CustomDivider(color: .black, height: 2, hPadding: 12)
            VStack {
                ForEach (0..<6) { rowIndex in
                    WeekOnMonth(calendar: calendar, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth)
                    if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
                }
                Spacer()
            }
        }
        .onAppear {
            request("http://115.68.248.159:5001/user/info/test123", "GET") { (success, data) in
                print(data)
            }

            // or

//            request("http://localhost:5000/test/post", "POST", ["key": "hello!"]) { (success, data) in
//              print(data)
//            }
        }
    }
}
