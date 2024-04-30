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
    @State var progress: CGFloat = 1
    
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
            
            HStack(spacing: CGFloat.fontSize / 6) {
                Text("\(record.record_count)")
                Text("/")
                Text("\(record.goal_count)")
            }
            .font(.system(size : CGFloat.fontSize * 2))
            .foregroundColor(color)
        }
        .onAppear {
            withAnimation {
                progress = record.issuccess ? 0 : 1 - (CGFloat(record.record_count * 100 / record.goal_count) / 100)
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