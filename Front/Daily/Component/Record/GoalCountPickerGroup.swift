//
//  GoalCountPickerGroup.swift
//  Daily
//
//  Created by 최승용 on 4/15/24.
//

import SwiftUI

struct GoalCountPickerGroup: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @Binding var type: String
    @Binding var count: Int
    @Binding var time: Int
    @Binding var isShowAlert: Bool
    @StateObject var timerViewModel: TimerViewModel = TimerViewModel()
    
    var body: some View {
        HStack {
            Spacer()
            if type == "timer" {
                Button {
                    if timerViewModel.timerIndex > 0 {
                        timerViewModel.timerIndex -= 1
                        time = timerViewModel.timeList[timerViewModel.timerIndex]
                    } else {
                        withAnimation {
                            alertViewModel.showToast(message: countRangeToastMessageText)
                        }
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
                        withAnimation {
                            alertViewModel.showToast(message: countRangeToastMessageText)
                        }
                    }
                } label: {
                    Image(systemName: "chevron.up.circle")
                }
            } else {
                Button {
                    if count > 1 {
                        count -= 1
                        if count == 1 {
                            type = "check"
                        }
                    } else {
                        withAnimation {
                            alertViewModel.showToast(message: countRangeToastMessageText)
                        }
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
                        withAnimation {
                            alertViewModel.showToast(message: countRangeToastMessageText)
                        }
                    }
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            Spacer()
        }
        .buttonStyle(.plain)
    }
}
