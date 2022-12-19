//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @StateObject var userInfo: UserInfo
    var body: some View {
        VStack {
            WeekIndicator(
                userInfo: userInfo,
                archievements: [0, 0, 0, 0, 0, 0, 0],
                tapPurpose: "change"
            )
            CustomDivider(color: .black, height: 2, hPadding: 12)
            List {
                ForEach (goalList) { goal in
                    GoalOnList(goal: goal)
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
    }
}
