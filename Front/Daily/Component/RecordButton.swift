//
//  RecordButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RecordButton: View {
    @StateObject var goal: Goal
    var body: some View {
        if goal.isSuccess {
            Label("완료", systemImage: "hand.thumbsup.circle")
        } else {
            Button {
                switch goal.type {
                case "check":
                    goal.isSuccess.toggle()
                case "count":
                    if goal.recordCount <  goal.goalCount { goal.recordCount += 1 }
                    if goal.recordCount == goal.goalCount { goal.isSuccess = true }
                case "timer":
                    goal.isStart.toggle()
                default:
                    print("catch error is record button")
                }
            } label: {
                switch goal.type {
                case "check":
                    Label("성공", systemImage: "checkmark.circle")
                case "count":
                    Label("추가", systemImage: "plus.circle")
                case "timer":
                    if goal.isStart { Label("중지", systemImage: "pause.circle") }
                    else            { Label("시작", systemImage: "play.circle") }
                default:
                    Text("")
                }
            }
        }
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordButton(goal: Goal())
    }
}
