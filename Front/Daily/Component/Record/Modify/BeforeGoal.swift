//
//  BeforeGoal.swift
//  Daily
//
//  Created by 최승용 on 4/15/24.
//

import SwiftUI

struct BeforeGoal: View {
    @Binding var record: RecordModel
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                if record.issuccess {
                    Image(systemName: "\(record.symbol.toSymbol()?.rawValue ?? "d.circle").fill")
                } else {
                    Image(systemName: "\(record.symbol.toSymbol()?.rawValue ?? "d.circle")")
                }
                Text(record.content)
                Spacer()
                Text("\(record.record_count) / \(record.goal_count)")
//                switch record.type {
//                case "check":
//                    Label("성공 기록", systemImage: "checkmark.circle")
//                case "count":
//                case "timer":
//                    Label("시간 기록", systemImage: "play.circle")
//                default:
//                    Text("")
//                }
            }
        }
        .padding(.horizontal, 5)
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 15).fill(Colors.background)
        }
        .padding(.horizontal, 5)
    }
}
