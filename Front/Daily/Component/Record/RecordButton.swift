//
//  RecordButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RecordButton: View {
    @StateObject var userInfo: UserInfo
    @Binding var record: RecordModel
    @Binding var archievements: [Double]
    var body: some View {
        if record.issuccess {
            Label("완료", systemImage: "hand.thumbsup.circle")
        } else {
            Button {
                switch record.type {
                case "check":
                    increaseCount(recordUID: String(record.uid)) { (data) in
                        record.record_count = data.data.record_count
                        record.issuccess = data.data.issuccess
                        // 임시 사용, 추후 observable 하게 수정 필요
                        getCalendarWeek2(
                            userID: String(userInfo.uid),
                            startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)
                        ) { (data) in
                            archievements = data.data.rating
                        }
                    }
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
