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
    @State var goals: Array<[String: Any]> = [["symbol": "test"]]
    var body: some View {
        VStack {
            WeekIndicator(
                userInfo: userInfo,
                archievements: $archievements,
                tapPurpose: "change"
            )
            CustomDivider(color: .black, height: 2, hPadding: 12)
            List {
                ForEach (goals.indices) { goalIndex in
                    let goal: [String: Any] = goals[goalIndex]
                    let text = goal["symbol"] as! String
                    Text(text)
                }
//                ForEach (goalList) { goal in
//                    GoalOnList(goal: goal)
//                        .swipeActions(allowsFullSwipe: true) {
//                            Button(role: .destructive) {
////                                goal.delete()
//                                print("delete")
//                            } label: {
//                                Label("Delete", systemImage: "trash")
//                            }
//                            Button() {
////                                goal.modify()
//                                print("modify")
//                            } label: {
//                                Label("Modify", systemImage: "pencil")
//                            }
//                            .tint(.orange)
//                        }
//                        .frame(height:50)
//                }
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
                print(data)
                let test: Array<[String: Any]> = data["goalList"] as! Array<[String: Any]>
                print(test)
                print(test[0])
                goals = test
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
        }
    }
}
