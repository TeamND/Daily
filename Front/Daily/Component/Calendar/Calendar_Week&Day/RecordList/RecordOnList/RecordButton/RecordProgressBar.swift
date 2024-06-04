//
//  RecordProgressBar.swift
//  Daily
//
//  Created by 최승용 on 4/30/24.
//

import SwiftUI

struct RecordProgressBar: View {
    @Binding var record: RecordModel
    @State var color: Color
    @State var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.primary.opacity(0.1), style: StrokeStyle(lineWidth: CGFloat.fontSize / 2, lineCap: .round))
            Circle()
                .trim(from: progress, to: 1)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [color.opacity(0.5), color]), startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: CGFloat.fontSize / 2, lineCap: .round))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
        }
        // ViewThatFits에 의해 ScrollView가 있는 RecordList에서 없는 RecordList로 변환되는 시점에 calendarViewModel의 recordsOnWeek가 먼저 비워지면서 onAppear는 불렸는데 해당 record가 존재하지 않아 out of range에러가 발생, onAppear 애니메이션을 제거하고 컴포넌트 선언과 동시에 progress를 직접 계산해 넣는 방식으로 변경
//        .onAppear {
//            withAnimation {
//                if record.type == "timer" {
//                    progress = record.issuccess ? 0 : 1 - (CGFloat(record.record_time * 100 / record.goal_time) / 100)
//                } else {
//                    progress = record.issuccess ? 0 : 1 - (CGFloat(record.record_count * 100 / record.goal_count) / 100)
//                }
//            }
//        }
        .onChange(of: record.record_time) { newValue in
            withAnimation {
                progress = record.issuccess ? 0 : 1 - (CGFloat(record.record_time * 100 / record.goal_time) / 100)
            }
        }
        .onChange(of: record.goal_time) { newValue in
            withAnimation {
                progress = record.issuccess ? 0 : 1 - (CGFloat(record.record_time * 100 / record.goal_time) / 100)
            }
        }
        .onChange(of: record.record_count) { newValue in
            withAnimation {
                progress = record.issuccess ? 0 : 1 - (CGFloat(record.record_count * 100 / record.goal_count) / 100)
            }
        }
        .onChange(of: record.goal_count) { newValue in
            withAnimation {
                progress = record.issuccess ? 0 : 1 - (CGFloat(record.record_count * 100 / record.goal_count) / 100)
            }
        }
    }
}
