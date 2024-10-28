//
//  DailyWeekIndicator.swift
//  Daily
//
//  Created by seungyooooong on 10/26/24.
//

import SwiftUI

struct DailyWeekIndicator: View {
    var mode: WeekIndicatorMode = .none
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(DayOfWeek.allCases, id: \.self) { dayOfWeek in
                ZStack {
                    let isToday = dayOfWeek == .sat
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                        .opacity(isToday && mode == .change ? 1 : 0)
                        .padding(CGFloat.fontSize / 3)
                    Image(systemName: "circle.fill")
                        .font(.system(size: CGFloat.fontSize * 5))
                        .foregroundStyle(Colors.daily.opacity(0.1))
                        .padding([.horizontal], -6) // AddGoalPopup에서 width가 늘어나는 현상 때문에 추가 -> 추후 확인 해보고 삭제
                    Text(dayOfWeek.text)
                        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                }
                .onTapGesture {
                    switch mode {
                    case .change:
                        print("change day is \(dayOfWeek)")
                    case .select:
                        print("select day is \(dayOfWeek)")
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

#Preview {
    DailyWeekIndicator()
}
