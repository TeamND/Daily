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
    var color: Color = Colors.daily
    
    var body: some View {
        Button {
            if dailyRecordViewModel.record.isSuccess {
                withAnimation { isAction = true }
            } else {
                switch dailyRecordViewModel.record.goal!.type {
                case .check, .count:
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
                    color: color,
                    progress: dailyRecordViewModel.record.goal!.type == .timer ? (dailyRecordViewModel.record.isSuccess ? 0 : 1 - (CGFloat(dailyRecordViewModel.record.count * 100 / dailyRecordViewModel.record.goal!.count) / 100)) : (dailyRecordViewModel.record.isSuccess ? 0 : 1 - (CGFloat(dailyRecordViewModel.record.count * 100 / dailyRecordViewModel.record.goal!.count) / 100))
                )
                
                if dailyRecordViewModel.record.isSuccess {
                    Image(systemName: "hand.thumbsup")
                        .scaleEffect(isAction ? 1.5 : 1)
                        .animation(.bouncy, value: 5)
                } else {    // TODO: 추후 timer 추가 시 수정
                    Image(systemName: "plus")
                }
            }
            .foregroundColor(color)
        }
        .onChange(of: isAction) { _, isAction in
            if isAction {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                    withAnimation { self.isAction = false }
                }
            }
        }
    }
}
