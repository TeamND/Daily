//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @State var goalList: [Goal] = [Goal(), Goal()]
    var body: some View {
        VStack {
            WeekIndicator(todayIndex: 2, archievements: [0.2, 0.4, 0.8, 0.4, 0.6, 0.4, 0], tapPurpose: "change")
            CustomDivider(color: .black, height: 2, hPadding: 12)
            List {
                ForEach (goalList) { goal in
                    GoalOnList(goal: goal)
                        .swipeActions(allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                print("delete")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button() {
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
