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
            WeekIndicator(userInfo: userInfo, archievements: .constant([0, 0, 0, 0, 0, 0, 0]))
            CustomDivider(color: .primary, height: 2, hPadding: 12)
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
            getCalendarMonth(
                userID: String(userInfo.uid),
                month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)"
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
            }
            // 데이터 타입 수정 이후 추후 적용
//            getCalendarMonth2(
//                userID: String(userInfo.uid),
//                month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)"
//            ) { (data) in
//                print("data is \(data)")
//            }
        }
        .onChange(of: userInfo.currentMonth) { month in
            print("calendar month(\(month)) change")
            getCalendarMonth(
                userID: String(userInfo.uid),
                month: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)"
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
            }
        }
    }
}
