//
//  DailyRecordButton.swift
//  Daily
//
//  Created by seungyooooong on 11/28/24.
//

import SwiftUI

struct DailyRecordButton: View {
    @ObservedObject var dailyRecordViewModel: DailyRecordViewModel
    @State var isAction: Bool = false
    
    var body: some View {
        Button {
            if dailyRecordViewModel.record.issuccess {
                withAnimation { isAction = true }
            } else {
                switch dailyRecordViewModel.record.type {
                case "check", "count":
                    dailyRecordViewModel.increaseCount()
//                case "timer": // TODO: 추후 구현
                default:
                    print("catch error is record button")
                }
            }
        } label: {
            ZStack {
                DailyRecordProgressBar(
                    record: $dailyRecordViewModel.record,
                    color: Colors.daily,
                    progress: dailyRecordViewModel.record.type == "timer" ? (dailyRecordViewModel.record.issuccess ? 0 : 1 - (CGFloat(dailyRecordViewModel.record.record_time * 100 / dailyRecordViewModel.record.goal_time) / 100)) : (dailyRecordViewModel.record.issuccess ? 0 : 1 - (CGFloat(dailyRecordViewModel.record.record_count * 100 / dailyRecordViewModel.record.goal_count) / 100))
                )
                
                if dailyRecordViewModel.record.issuccess {
                    Image(systemName: "hand.thumbsup")
                        .scaleEffect(isAction ? 1.5 : 1)
                        .animation(.bouncy, value: 5)
                } else {    // TODO: 추후 timer 추가 시 수정
                    Image(systemName: "plus")
                }
            }
            .foregroundColor(Colors.daily)
        }
        .onChange(of: isAction) { isAction in
            if isAction {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                    withAnimation { self.isAction = false }
                }
            }
        }
    }
}
