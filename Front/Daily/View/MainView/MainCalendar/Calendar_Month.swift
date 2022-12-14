//
//  Calendar_Month.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Month: View {
    @StateObject var userInfo: UserInfo
    @State var days: [[String: Any]] = Array(repeating: ["0": []], count: 42)
    var body: some View {
        let startDayIndex = userInfo.startDayIndex()
        let lengthOfMonth = userInfo.lengthOfMonth()
        let dividerIndex = (lengthOfMonth + startDayIndex - 1) / 7
        VStack {
            WeekIndicator(userInfo: userInfo)
            CustomDivider(color: .black, height: 2, hPadding: 12)
            VStack {
                ForEach (0..<6) { rowIndex in
                    WeekOnMonth(userInfo: userInfo, days: $days, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth)
                    if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
                }
                Spacer()
            }
        }
        .onAppear {
            print("calendar month(\(userInfo.currentMonth)) appear")
//            getCalendarMonth(
//                userID: String(userInfo.uid),
//                month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)"
            getCalendarMonth(
                userID: "2",
                month: "2022-12"
            ) { (success, data) in
                days = []
                let startDayIndex = userInfo.startDayIndex()
                let lengthOfMonth = userInfo.lengthOfMonth()
                for i in 0..<42 {
                    if i < startDayIndex || i > startDayIndex + lengthOfMonth - 1 { days.append(["0": []]) }
                    else {
                        let day = String(format: "%02d", i - startDayIndex + 1)
                        days.append([day: data[day] as? [String: Any] ?? []])
                    }
                }
                
                
//                print(data)
//                let dayFour = data["04"] as! [String: Any]
//                print("dayFour is \(dayFour)")
//                let dayFourRating = dayFour["rating"] as! Double
//                let dayFourSymbolArray = dayFour["symbol"] as! NSArray
//                print("dayFourRating is \(dayFourRating)")
//                print("dayFourSymbolArray is \(dayFourSymbolArray)")
//                for symbol in dayFourSymbolArray {
//                    let test = symbol as! [String: Bool]
//                    print(test)
//                }
            }
        }
        .onChange(of: userInfo.currentMonth) { month in
            print("calendar month(\(month)) change")
            // getCalendarMonth
        }
    }
}
