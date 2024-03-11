//
//  GoalDateOrRepeatSetting.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct GoalDateOrRepeatSetting: View {
    @StateObject var userInfo: UserInfo
    @StateObject var goal: Goal
    @State var year: String = String(String(Date().year).suffix(2))
    @State var month: String = String(format: "%02d", Date().month)
    @State var startDate: Date = Date()
    @State var endDate: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
    var body: some View {
        Text("날짜 or 반복 설정")
            .font(.system(size: 20, weight: .bold))
        HStack {
            Picker("", selection: $goal.dateOrRepeat) {
                ForEach(["날짜", "반복"], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(2)
            .cornerRadius(15)
        }
        .font(.system(size: 16))
        switch goal.dateOrRepeat {
        case "날짜":
            MultiDatePickerOnCalendar(year: year, month: month)
            Text("MonthOnYear for date pick")
        case "반복":
//            WeekIndicator(userInfo: userInfo, tapPurpose: "select")
            Text("week indicator for date pick")
            DatePicker("시작일:", selection: $startDate, in: Date()..., displayedComponents: .date)
                .onAppear { goal.start_date = startDate.toString() }
            DatePicker("종료일:", selection: $endDate, in: Date()..., displayedComponents: .date)
                .onAppear { goal.end_date = endDate.toString() }
        default:
            Text("")
        }
    }
}
