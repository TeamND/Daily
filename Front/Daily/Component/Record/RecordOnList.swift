//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct RecordOnList: View {
    @StateObject var userInfo: UserInfo
    @StateObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                if record.issuccess {
                    Image(systemName: "\(record.symbol.toSymbol()?.rawValue ?? "d.circle").fill")
                } else {
                    Image(systemName: "\(record.symbol.toSymbol()?.rawValue ?? "d,circle")")
                }
                Text(record.content)
                Spacer()
                RecordButton(userInfo: userInfo, calendarViewModel: calendarViewModel, record: $record)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(.mint)
            }
            if record.type != "check" {
                VStack {
                    Spacer()
                    ProgressView(value: Double(record.record_count), total: Double(record.goal_count))
                        .progressViewStyle(LinearProgressViewStyle(tint: .mint.opacity(0.8)))
                }
                .padding(.vertical, 4)
            }
        }
    }
}
