//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct RecordOnList: View {
    @StateObject var userInfo: UserInfo
    @Binding var record: RecordModel
    @Binding var archievements: [Double]
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
//                Image(systemName: record.symbol)
                if record.symbol == "운동" {
                    if record.issuccess {
                        Image(systemName: "dumbbell.fill")
                    } else {
                        Image(systemName: "dumbbell")
                    }
                } else { Image(systemName: "pencil") }
                Text(record.content)
                Spacer()
                RecordButton(userInfo: userInfo, record: $record, archievements: $archievements)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(.mint)
            }
            .padding(.horizontal, 12)
            if record.type != "check" {
                VStack {
                    Spacer()
                    ProgressView(value: Double(record.record_count), total: Double(record.goal_count))
                        .progressViewStyle(LinearProgressViewStyle(tint: .mint.opacity(0.8)))
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.green, lineWidth: 2)
        }
    }
}
