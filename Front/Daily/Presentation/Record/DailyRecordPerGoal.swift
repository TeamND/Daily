//
//  DailyRecordPerGoal.swift
//  Daily
//
//  Created by seungyooooong on 11/28/24.
//

import SwiftUI

struct DailyRecordPerGoal: View {
    @Binding var record: DailyRecordModel
    let paddingTrailing: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack(spacing: CGFloat.fontSize / 6) {
                    if record.goal!.type == .timer {
                        Text(record.count.timerFormat())
                        Text("/")
                        Text(record.goal!.count.timerFormat())
                    } else {
                        Text("\(record.count)")
                        Text("/")
                        Text("\(record.goal!.count)")
                    }
                }
                .font(.system(size : CGFloat.fontSize * 2))
                Spacer()
            }
            .padding(.top, CGFloat.fontSize)
            .padding(.trailing, paddingTrailing)
        }
    }
}
