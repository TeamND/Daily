//
//  GoalCountPickerGroup.swift
//  Daily
//
//  Created by 최승용 on 4/15/24.
//

import SwiftUI

struct GoalCountPickerGroup: View {
    @Binding var type: String
    @Binding var count: Int
    @Binding var time: Int
    @Binding var isShowAlert: Bool
    @Binding var isShowCountRangeAlert: Bool
    @StateObject var timerViewModel: TimerViewModel = TimerViewModel()
    
    var body: some View {
        HStack {
            if type == "timer" {
                Text("목표 시간 : ")
                Button {
                    if timerViewModel.timerIndex > 0 {
                        timerViewModel.timerIndex -= 1
                        time = timerViewModel.timeList[timerViewModel.timerIndex]
                    } else {
                        isShowAlert = true
                        isShowCountRangeAlert = true
                    }
                } label: {
                    Image(systemName: "chevron.down.circle")
                }
                Text(timerViewModel.timeToString(time: time))
                    .frame(width: CGFloat.fontSize * 10)
                    .onAppear {
                        timerViewModel.findTimerIndex(time: time)
                    }
                Button {
                    if timerViewModel.timerIndex < timerViewModel.timeList.count - 1 {
                        timerViewModel.timerIndex += 1
                        time = timerViewModel.timeList[timerViewModel.timerIndex]
                    } else {
                        isShowAlert = true
                        isShowCountRangeAlert = true
                    }
                } label: {
                    Image(systemName: "chevron.up.circle")
                }
            } else {
                Text("목표 횟수 : ")
                Button {
                    if count > 1 {
                        count -= 1
                        if count == 1 {
                            type = "check"
                        }
                    } else {
                        isShowAlert = true
                        isShowCountRangeAlert = true
                    }
                } label: {
                    Image(systemName: "minus.circle")
                }
                Text("\(count)")
                    .frame(width: CGFloat.fontSize * 10)
                Button {
                    if count < 10 {
                        count += 1
                        type = "count"
                    } else {
                        isShowAlert = true
                        isShowCountRangeAlert = true
                    }
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .buttonStyle(.plain)
    }
}
