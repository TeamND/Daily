//
//  DailyWeekIndicator.swift
//  Daily
//
//  Created by seungyooooong on 10/26/24.
//

import SwiftUI

struct DailyWeekIndicator: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    var mode: WeekIndicatorMode
    @Binding var opacity: [Double]
    
    init(mode: WeekIndicatorMode = .none, opacity: Binding<[Double]> = Binding(get: { Array(repeating: 0, count: 7) }, set: { _ in })) {
        self.mode = mode
        self._opacity = opacity
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(DayOfWeek.allCases, id: \.self) { dayOfWeek in
                ZStack {
                    let isSelectedDay = dailyCalendarViewModel.currentDate.weekday == dayOfWeek.index + 1
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                        .opacity(isSelectedDay && mode == .change ? 1 : 0)
                        .padding(CGFloat.fontSize / 3)
                    Image(systemName: "circle.fill")
                        .font(.system(size: CGFloat.fontSize * 5))
                        .foregroundStyle(Colors.daily.opacity(opacity[dayOfWeek.index]))
                    Text(dayOfWeek.text)
                        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                }
                .onTapGesture {
                    switch mode {
                    case .change:
                        dailyCalendarViewModel.setDate(byAdding: .day, value: dayOfWeek.index - (dailyCalendarViewModel.currentDate.weekday - 1))
                    case .select:
                        withAnimation {
                            opacity[dayOfWeek.index] = opacity[dayOfWeek.index] == 0.8 ? 0 : 0.8
                        }
                    case .none:
                        break
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: CGFloat.fontSize * 6)
        .frame(maxWidth: .infinity)
    }
}
