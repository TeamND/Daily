//
//  GoalCountOrTimeSetting.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct GoalCountOrTimeSetting: View {
    @StateObject var goal: Goal
    var body: some View {
        Text("횟수 or 시간 설정")
            .font(.system(size: 20, weight: .bold))
        HStack {
            Picker("", selection: $goal.countOrTime) {
                ForEach(["횟수", "시간"], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(2)
            .cornerRadius(15)
        }
        .font(.system(size: 16))
        switch goal.countOrTime {
        case "횟수":
            HStack {
                Spacer()
                Button {
                    if goal.goal_count > 1 { goal.goal_count -= 1 }
                } label: {
                    Image(systemName: "minus.circle")
                }
                Spacer()
                Text(String(goal.goal_count))
                Spacer()
                Button {
                    if goal.goal_count < 10 { goal.goal_count += 1}
                } label: {
                    Image(systemName: "plus.circle")
                }
                Spacer()
            }
        case "시간":
            HStack {
                Spacer()
                Button {
                    if goal.goalTimeIndex > 0 { goal.goalTimeIndex -= 1 }
                } label: {
                    Image(systemName: "chevron.down.circle")
                }
                Spacer()
                Text(times[goal.goalTimeIndex])
                Spacer()
                Button {
                    if goal.goalTimeIndex < 9 { goal.goalTimeIndex += 1 }
                } label: {
                    Image(systemName: "chevron.up.circle")
                }
                Spacer()
            }
        default:
            Text("")
        }
    }
}
