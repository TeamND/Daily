//
//  RecordButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RecordButton: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    @Binding var isBeforeRecord: Bool
    @State var isAction = false
    
    var body: some View {
        if isBeforeRecord {
            ZStack {
                RecordProgressBar(record: $record, color: .primary, progress: record.type == "timer" ? (record.issuccess ? 0 : 1 - (CGFloat(record.record_time * 100 / record.goal_time) / 100)) : (record.issuccess ? 0 : 1 - (CGFloat(record.record_count * 100 / record.goal_count) / 100)))
                HStack {
                    if record.issuccess {
                        Image(systemName: "hand.thumbsup")
                    } else {
                        if record.type == "timer" {
                            if record.start_time2 == nil {
                                Image(systemName: "play")
                            } else {
                                Image(systemName: "pause")
                            }
                        } else {
                            Image(systemName: "plus")
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        } else {
            Button {
                if record.issuccess {
                    isAction = true
                } else {
                    switch record.type {
                    case "check", "count":
                        increaseCount(recordUID: String(record.uid)) { (data) in
                            if data.code == "00" {
                                calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
                                    if code == "99" { alertViewModel.showAlert() }
                                }
                            } else {
                                alertViewModel.showAlert()
                            }
                        }
                    case "timer":
                        let isStart = record.start_time2 == nil
                        record.start_time2 = Date().toString()
                        startTimer(startTimerRequestModel: startTimerRequestModel(record: record)) { (data) in
                            print("startTimer result is \(data)")
                            DispatchQueue.main.async {
                                if isStart {
                                    print("timer start!!!!!")
                                } else {
                                    // 타이머 구현 전까지 임시로 사용, 추후 수정
//                                    record.record_time += data.data.start_time
//                                    print("record_time \(data.data.start_time) 만큼 더해서 재설정")
                                    print("sync..?")
                                    record.start_time2 = nil
                                }
                            }
                        }
                    default:
                        print("catch error is record button")
                    }
                }
            } label: {
                ZStack {
                    RecordProgressBar(record: $record, color: Colors.daily, progress: record.type == "timer" ? (record.issuccess ? 0 : 1 - (CGFloat(record.record_time * 100 / record.goal_time) / 100)) : (record.issuccess ? 0 : 1 - (CGFloat(record.record_count * 100 / record.goal_count) / 100)))
                    
                    HStack {
                        if record.issuccess {
                            Image(systemName: "hand.thumbsup")
                                .scaleEffect(isAction ? 1.5 : 1)
                                .animation(.bouncy, value: 5)
                        } else {
                            if record.type == "timer" {
                                if record.start_time2 == nil {
                                    Image(systemName: "play")
                                } else {
                                    Image(systemName: "pause")
                                }
                            } else {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .foregroundColor(Colors.daily)
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
