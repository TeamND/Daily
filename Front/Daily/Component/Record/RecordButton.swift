//
//  RecordButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RecordButton: View {
    @Binding var record: RecordModel
    var body: some View {
        if record.issuccess {
            Label("완료", systemImage: "hand.thumbsup.circle")
        } else {
            Button {
                switch record.type {
                case "check":
                    print("record.isSuccess.toggle()")
//                    record.issuccess.toggle()
                case "count":
                    print("미구현")
//                    if record.record_count <  record.goal_count { record.record_count += 1 }
//                    if record.record_count == record.goal_count { record.issuccess = true }
                case "timer":
                    print("timer record button press")
//                    record.itart.toggle()
                default:
                    print("catch error is record button")
                }
            } label: {
                switch record.type {
                case "check":
                    Label("성공", systemImage: "checkmark.circle")
                case "count":
                    Label("추가", systemImage: "plus.circle")
                case "timer":
                    Text("timer")
//                    if record.isStart { Label("중지", systemImage: "pause.circle") }
//                    else              { Label("시작", systemImage: "play.circle") }
                default:
                    Text("")
                }
            }
        }
    }
}
