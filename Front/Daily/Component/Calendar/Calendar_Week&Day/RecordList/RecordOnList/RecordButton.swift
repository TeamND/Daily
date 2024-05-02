//
//  RecordButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RecordButton: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    @Binding var isBeforeRecord: Bool
    @State var isAction = false
    
    var body: some View {
        if isBeforeRecord {
            RecordProgressBar(record: $record, color: .primary)
        } else {
            Button {
                if record.issuccess {
                    isAction = true
                } else {
                    switch record.type {
                    case "check", "count":
                        increaseCount(recordUID: String(record.uid)) { (data) in
                            if data.code == "00" {
                                calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel)
                            }
                        }
                    case "timer":
                        let isStart = record.start_time == pauseTime
                        record.start_time = Date().toString()
                        startTimer(startTimerRequestModel: startTimerRequestModel(record: record)) { (data) in
                            DispatchQueue.main.async {
                                if isStart {
                                    print("timer start!!!!!")
                                } else {
                                    // 타이머 구현 전까지 임시로 사용, 추후 수정
                                    record.record_time += data.data.start_time
//                                    print("record_time \(data.data.start_time) 만큼 더해서 재설정")
                                    print("sync..?")
                                    record.start_time = pauseTime
                                }
                            }
                        }
                    default:
                        print("catch error is record button")
                    }
                }
            } label: {
                ZStack {
                    RecordProgressBar(record: $record, color: Color("CustomColor"))
//                    Group {
//                        if record.type == "timer" {
//                            VStack {
//                                Text(record.record_time.timerFormat())
//                                Text(record.goal_time.timerFormat())
//                            }
//                            .font(.system(size : CGFloat.fontSize * 1.5))
//                        } else {
//                            HStack(spacing: CGFloat.fontSize / 6) {
//                                Text("\(record.record_count)")
//                                Text("/")
//                                Text("\(record.goal_count)")
//                            }
//                            .font(.system(size : CGFloat.fontSize * 2))
//                        }
//                    }
//                    .padding(.trailing, 60)
                    Image(systemName: "hand.thumbsup.circle")
                        .font(.system(size: CGFloat.fontSize * 4))
                        .background(Color("BackgroundColor"))
                        .cornerRadius(15)
                        .foregroundColor(Color("CustomColor"))
                        .scaleEffect(isAction ? 1 : 0)
                        .animation(.bouncy, value: 5)
                }
                .onChange(of: isAction) { newValue in
                    if isAction == true {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                            withAnimation {
                                isAction = false
                            }
                        }
                    }
                }
            }
        }
    }
}
