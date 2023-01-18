//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @StateObject var userInfo: UserInfo
    @State var archievements: [Double] = Array(repeating: 0.0, count: 7)
    @State var records: Array<[String: Any]> = []
    var body: some View {
        VStack {
            WeekIndicator(
                userInfo: userInfo,
                archievements: $archievements,
                tapPurpose: "change"
            )
            CustomDivider(color: .black, height: 2, hPadding: 12)
            List {
                ForEach (records.indices, id: \.self) { recordIndex in
                    let record: [String: Any] = records[recordIndex]
                    let recordObject: Record = Record(
                        uid: record["uid"] as! Int,
                        goal_uid: record["goal_uid"] as! Int,
                        content: record["content"] as! String,
                        type: record["type"] as! String,
                        symbol: record["symbol"] as! String,
                        goal_time: record["goal_time"] as! Int,
                        goal_count: record["goal_count"] as! Int,
                        record_time: record["record_time"] as! Int,
                        record_count: record["record_count"] as! Int,
                        issuccess: record["issuccess"] as! Bool,
                        start_time: record["start_time"] as! String
                    )
                    GoalOnList(record: recordObject)
                        .swipeActions(allowsFullSwipe: true) {
                            Button(role: .destructive) {
//                                goal.delete()
                                print("delete")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button() {
//                                goal.modify()
                                print("modify")
                            } label: {
                                Label("Modify", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                        .frame(height:50)
                }
            }
            .listStyle(.plain)
        }
        .onAppear {
            print("calendar week&day(\(userInfo.currentDay)) appear")
            getCalendarWeek(
                userID: String(userInfo.uid),
                startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)
            ) { (success, data) in
                archievements = data["rating"] as! [Double]
            }
            getCalendarDay(
                userID: String(userInfo.uid),
                day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)"
            ) { (success, data) in
                records = data["goalList"] as! Array<[String: Any]>
            }
        }
        .onChange(of: userInfo.currentDay) { day in
            print("calendar week&day(\(day)) change")
            getCalendarWeek(
                userID: String(userInfo.uid),
                startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)
            ) { (success, data) in
                archievements = data["rating"] as! [Double]
            }
            getCalendarDay(
                userID: String(userInfo.uid),
                day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)"
            ) { (success, data) in
                records = data["goalList"] as! Array<[String: Any]>
            }
        }
    }
}
