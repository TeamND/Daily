//
//  RecordButton.swift
//  Daily
//
//  Created by seungyooooong on 11/28/24.
//

import SwiftUI

struct RecordButton: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    @State private var isAction: Bool = false
    
    let record: DailyRecordModel
    var color: Color = Colors.daily
    
    var body: some View {
        Button {
            if record.isSuccess {
                withAnimation { isAction = true }
            } else {
                calendarViewModel.actionOfRecordButton(record: record)
            }
        } label: {
            ZStack {
                DailyRecordProgressBar(record: record, color: color)
                if record.isSuccess {
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

// MARK: - DailyRecordProgressBar
struct DailyRecordProgressBar: View {
    let record: DailyRecordModel
    let color: Color
    
    init(record: DailyRecordModel, color: Color) {
        self.record = record
        self.color = color
    }
    
    var body: some View {
        // FIXME: 추후 progressBar UI 수정하면서 함께 수정
        if let goal = record.goal {
            ZStack {
                Circle()
                    .stroke(Colors.reverse.opacity(0.1), style: StrokeStyle(lineWidth: CGFloat.fontSize / 2, lineCap: .round))
                Circle()
                    .trim(from: record.isSuccess ? 0 : 1 - (CGFloat(record.count * 100 / goal.count) / 100), to: 1)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.5), color]), startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: CGFloat.fontSize / 2, lineCap: .round))
                    .rotationEffect(Angle(degrees: 90))
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
            }
            .animation(.easeInOut(duration: 0.5), value: record.isSuccess)
            .animation(.easeInOut(duration: 0.5), value: record.count)
        }
    }
}
