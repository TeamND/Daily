//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var tabViewModel: TabViewModel
    @State var archievements: [Double] = Array(repeating: 0.0, count: 7)
    @State var records: [RecordModel] = []
    var body: some View {
        VStack {
            WeekIndicator(
                userInfo: userInfo,
                archievements: $archievements,
                tapPurpose: "change"
            )
            CustomDivider(color: .primary, height: 2, hPadding: 12)
            if records.count > 0 {
                List {
                    ForEach ($records, id:\.self.uid) { record in
                        RecordOnList(userInfo: userInfo, record: record, archievements: $archievements)
                            .swipeActions(allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteGoal(goalUID: String(record.goal_uid.wrappedValue)) { data in
                                        if data.code == "00" { print("\(record.goal_uid) delete success") }
                                        else                 { print("\(record.goal_uid) delete fail@@@") }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
//                                Button() {
//                                    print("modify")
//                                } label: {
//                                    Label("Modify", systemImage: "pencil")
//                                }
//                                .tint(.orange)
                            }
                            .frame(minHeight: 40)
                    }
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
            } else {
                NoRecord(tabViewModel: tabViewModel)
            }
        }
        .onAppear {
            getCalendarWeek2(
                userID: String(userInfo.uid),
                startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)
            ) { (data) in
                archievements = data.data.rating
            }
            getCalendarDay2(
                userID: String(userInfo.uid),
                day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)"
            ) { (data) in
                records = data.data.goalList
            }
        }
        .onChange(of: userInfo.currentDay) { day in
            getCalendarWeek2(
                userID: String(userInfo.uid),
                startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)
            ) { (data) in
                archievements = data.data.rating
            }
            getCalendarDay2(
                userID: String(userInfo.uid),
                day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)"
            ) { (data) in
                records = data.data.goalList
            }
        }
    }
}
