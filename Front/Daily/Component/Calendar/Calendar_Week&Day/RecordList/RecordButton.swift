//
//  RecordButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RecordButton: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    var body: some View {
        if record.issuccess {
            Label("완료", systemImage: "hand.thumbsup.circle")
        } else {
            Button {
                switch record.type {
                case "check", "count":
                    increaseCount(recordUID: String(record.uid)) { (data) in
                        if data.code == "00" {
                            DispatchQueue.main.async {
                                record.record_count = data.data.record_count
                                record.issuccess = data.data.issuccess
                                getCalendarWeek(userID: String(userInfo.uid), startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)) { (data) in
                                    calendarViewModel.setRatingOnWeek(ratingOnWeek: data.data.rating)
                                }
                            }
                        }
                    }
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
