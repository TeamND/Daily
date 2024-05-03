//
//  RecordPerGoal.swift
//  Daily
//
//  Created by 최승용 on 5/3/24.
//

import SwiftUI

struct RecordPerGoal: View {
    @Binding var record: RecordModel
    @State var paddingTrailing: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack(spacing: CGFloat.fontSize / 6) {
                    if record.type == "timer" {
                        Text(record.record_time.timerFormat())
                        Text("/")
                        Text(record.goal_time.timerFormat())
                    } else {
                        Text("\(record.record_count)")
                        Text("/")
                        Text("\(record.goal_count)")
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
