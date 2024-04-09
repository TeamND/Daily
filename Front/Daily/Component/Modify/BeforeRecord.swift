//
//  BeforeRecord.swift
//  Daily
//
//  Created by 최승용 on 4/9/24.
//

import SwiftUI

struct BeforeRecord: View {
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
                if record.issuccess {
                    Label("완료", systemImage: "hand.thumbsup.circle")
                } else {
                    switch record.type {
                    case "check":
                        Label("성공", systemImage: "checkmark.circle")
                    case "count":
                        Label("추가", systemImage: "plus.circle")
                    case "timer":
                        Text("timer")
    //                    if record.isStart { Label("중지", systemImage: "pause.circle") }
    //                    else              { Label("시작", systemImage: "play.circle") }
                    default:
                        Text("")
                    }
                }
            }
            if record.type != "check" {
                VStack {
                    Spacer()
                    ProgressView(value: Double(record.record_count), total: Double(record.goal_count))
                        .progressViewStyle(LinearProgressViewStyle(tint: Color("CustomColor").opacity(0.8)))
                }
                .padding(.vertical, 4)
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
