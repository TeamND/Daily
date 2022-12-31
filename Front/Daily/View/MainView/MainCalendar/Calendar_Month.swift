//
//  Calendar_Month.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Month: View {
    @StateObject var userInfo: UserInfo
    var body: some View {
        let startDayIndex = userInfo.startDayIndex()
        let lengthOfMonth = userInfo.lengthOfMonth()
        let dividerIndex = (lengthOfMonth + startDayIndex - 1) / 7
        VStack {
            WeekIndicator(userInfo: userInfo)
            CustomDivider(color: .black, height: 2, hPadding: 12)
            VStack {
                ForEach (0..<6) { rowIndex in
                    WeekOnMonth(userInfo: userInfo, rowIndex: rowIndex, startDayIndex: startDayIndex, lengthOfMonth: lengthOfMonth)
                    if rowIndex < dividerIndex { CustomDivider(hPadding: 20) }
                }
                Spacer()
            }
        }
        .onAppear {
            print("calendar month(\(userInfo.currentMonth)) appear")
//            getCalendarMonth(
//                userID: String(userInfo.uid),
//                month: "\(String(userInfo.currentYear))-\(String(format: "%02d", userInfo.currentMonth))"
            getCalendarMonth(
                userID: "2",
                month: "2022-12"
            ) { (success, data) in
                print(data)
                let dayFour = data["04"] as! [String: Any]
                print("dayFour is \(dayFour)")
                let dayFourRating = dayFour["rating"] as! Double
                let dayFourSymbolArray = dayFour["symbol"] as! NSArray
                print("dayFourRating is \(dayFourRating)")
                print("dayFourSymbolArray is \(dayFourSymbolArray)")
                for symbol in dayFourSymbolArray {
                    let test = symbol as! [String: Bool]
                    print(test)
                }
//                for month in 1...12 {
//                    let archievements = data[String(format: "%02d", month)] as? [String: Any] ?? ["0": 0]
//                    allArchievements[month-1] = []
//                    let startIndex = userInfo.startDayIndex(month: month)
//                    for row in 0..<6 {
//                        for col in 0..<7 {
//                            let day = row * 7 + col + 1 - startIndex
//                            if row * 7 + col < startIndex { allArchievements[month-1].append(0) }
//                            else { allArchievements[month-1].append(archievements[String(format: "%02d", day)] as? Double ?? 0) }
//                        }
//                    }
//                }
            }
        }
        .onChange(of: userInfo.currentMonth) { month in
            print("calendar month(\(month)) change")
            // getCalendarMonth
        }
    }
}
