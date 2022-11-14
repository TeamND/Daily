//
//  DayOnMonth.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import SwiftUI

struct DayOnMonth: View {
    @StateObject var calendar: Calendar
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentColor.opacity(0.4))
                Text("1")
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
        .onTapGesture {
            calendar.state = "Week&Day"
        }
    }
}

struct DayOnMonth_Previews: PreviewProvider {
    static var previews: some View {
        DayOnMonth(calendar: Calendar())
            .previewLayout(.fixed(width: 40, height: 80))
            .accentColor(.mint)
    }
}
