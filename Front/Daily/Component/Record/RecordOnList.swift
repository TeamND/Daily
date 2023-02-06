//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct RecordOnList: View {
    @StateObject var record: Record
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
//                Image(systemName: record.symbol)
                if record.symbol == "운동" { Image(systemName: "dumbbell.fill") }
                else { Image(systemName: "dumbbell") }
                Text(record.content)
                Spacer()
                RecordButton(record: record)
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
