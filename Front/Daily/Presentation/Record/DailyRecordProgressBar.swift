//
//  DailyRecordProgressBar.swift
//  Daily
//
//  Created by seungyooooong on 11/28/24.
//

import SwiftUI

struct DailyRecordProgressBar: View {
    let record: DailyRecordModel
    let color: Color
    
    var body: some View {
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
        }
    }
}
