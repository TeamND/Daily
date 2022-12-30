//
//  Calendar_Year.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Year: View {
    @StateObject var userInfo: UserInfo
    @State var allArchievements: [[Double]] = Array(repeating: Array(repeating: 0, count: 42), count: 12)
    var body: some View {
        VStack(spacing: 0) {
            CustomDivider(color: .black, height: 2)
                .padding(12)
            ForEach (0..<4) { rowIndex in
                HStack(spacing: 0) {
                    ForEach (0..<3) { colIndex in
                        let month = (rowIndex * 3) + colIndex + 1
                        Button {
                            withAnimation {
                                userInfo.currentMonth = month
                                userInfo.currentState = "month"
                            }
                        } label: {
                            MonthOnYear(userInfo: userInfo, archievements: $allArchievements[month-1], month: month)
                                .accentColor(.black)
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            getCalendarYear(userID: String(userInfo.uid), year: String(userInfo.currentYear)) { (success, data) in
                for month in 1...12 {
                    let archievements = data[String(format: "%02d", month)] as? [String: Any] ?? ["0": 0]
                    allArchievements[month-1] = []
                    let startIndex = userInfo.startDayIndex(year: userInfo.currentYear, month: month)
                    for row in 0..<6 {
                        for col in 0..<7 {
                            let day = row * 7 + col + 1 - startIndex
                            if row * 7 + col < startIndex { allArchievements[month-1].append(0) }
                            else { allArchievements[month-1].append(archievements[String(format: "%02d", day)] as? Double ?? 0) }
                        }
                    }
                }
            }
            print("calendar year appear")
            print(userInfo.currentYear)
        }
        .onChange(of: userInfo.currentYear) { year in
            getCalendarYear(userID: String(userInfo.uid), year: String(userInfo.currentYear)) { (success, data) in
                for month in 1...12 {
                    let archievements = data[String(format: "%02d", month)] as? [String: Any] ?? ["0": 0]
                    allArchievements[month-1] = []
                    let startIndex = userInfo.startDayIndex(year: userInfo.currentYear, month: month)
                    for row in 0..<6 {
                        for col in 0..<7 {
                            let day = row * 7 + col + 1 - startIndex
                            if row * 7 + col < startIndex { allArchievements[month-1].append(0) }
                            else { allArchievements[month-1].append(archievements[String(format: "%02d", day)] as? Double ?? 0) }
                        }
                    }
                }
            }
            print("calendar year change")
            print(year)
        }
    }
}
