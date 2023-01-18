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
    @State var goals: Array<[String: Any]> = []
    var body: some View {
        VStack {
            WeekIndicator(
                userInfo: userInfo,
                archievements: $archievements,
                tapPurpose: "change"
            )
            CustomDivider(color: .black, height: 2, hPadding: 12)
            List {
                ForEach (goals.indices, id: \.self) { goalIndex in
                    let goal: [String: Any] = goals[goalIndex]
                    let goalObject: Goal = Goal(
                        uid: goal["uid"] as! Int,
                        user_uid: goal["user_uid"] as? Int ?? 0,
                        content: goal["content"] as? String ?? "",
                        type: goal["type"] as! String,
                        symbol: goal["symbol"] as! String,
                        start_date: goal["start_date"] as? String ?? "",
                        end_date: goal["end_date"] as? String ?? "",
                        cycle_type: goal["cycle_type"] as? String ?? "",
                        cycle_date: goal["cycle_date"] as? String ?? "",
                        goal_time: goal["goal_time"] as! String,
                        goal_count: goal["goal_count"] as! Int
                    )
                    GoalOnList(goal: goalObject)
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
//            getCalendarDay(
//                userID: String(userInfo.uid),
//                day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)"
            getCalendarDay(
                userID: "2",
                day: "2022-12-04"
            ) { (success, data) in
                goals = data["goalList"] as! Array<[String: Any]>
                print(goals)
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
//            getCalendarDay(
//                userID: String(userInfo.uid),
//                day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)"
            getCalendarDay(
                userID: "2",
                day: "2022-12-04"
            ) { (success, data) in
                goals = data["goalList"] as! Array<[String: Any]>
            }
        }
    }
}
