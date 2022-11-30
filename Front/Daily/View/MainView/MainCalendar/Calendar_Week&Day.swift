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
            HStack {
                ForEach (kWeeks[0], id: \.self) { week in
                    Spacer()
                    ZStack {
                        let isToday = week == "수"
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.green, lineWidth: 2)
                            .opacity(isToday ? 1 : 0)
                            .padding([.top, .bottom], -2)
                        Image(systemName: "circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.mint.opacity(0.4))
                        Text(week)
                            .font(.system(size: 16, weight: .bold))
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 30)
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
