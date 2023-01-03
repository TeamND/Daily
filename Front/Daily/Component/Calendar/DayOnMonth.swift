//
//  DayOnMonth.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import SwiftUI

struct DayOnMonth: View {
    let day: Int
    @Binding var dayObject: [String: Any]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: 24))
//                    .foregroundColor(.mint.opacity(0.2))
                    .foregroundColor(.mint.opacity(dayObject["rating"] as? Double ?? 0))
                Text("\(day)")
                    .font(.system(size: 12, weight: .bold))
            }
            VStack(spacing: 8) {
                HStack(spacing: 2) {
                    Image(systemName: "dumbbell.fill")
                    Image(systemName: "highlighter")
                }
                HStack(spacing: 2) {
                    Image(systemName: "highlighter")
                    Image(systemName: "dumbbell.fill")
                }
            }
            .font(.system(size: 12, weight: .bold))
        }
        .onAppear {
            print("day is \(day), dayObject is \(dayObject)")
        }
    }
}
