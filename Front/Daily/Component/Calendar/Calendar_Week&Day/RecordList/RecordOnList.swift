//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import SwiftUI

struct RecordOnList: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                if record.issuccess {
                    Image(systemName: "\(record.symbol.toSymbol()?.rawValue ?? "d.circle").fill")
                } else {
                    Image(systemName: "\(record.symbol.toSymbol()?.rawValue ?? "d.circle")")
                }
                Text(record.content)
                Spacer()
                RecordButton(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: $record)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(Color("CustomColor"))
            }
            if record.type != "check" {
                RecordProgressBar(record_count: $record.record_count, goal_count: $record.goal_count)
            }
        }
        .padding(.horizontal, 5)
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 15).fill(Color("BackgroundColor"))
        }
        .padding(.horizontal, 5)
    }
}
