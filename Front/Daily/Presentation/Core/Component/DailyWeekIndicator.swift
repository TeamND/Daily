//
//  DailyWeekIndicator.swift
//  Daily
//
//  Created by seungyooooong on 10/26/24.
//

import SwiftUI
import SwiftData

struct DailyWeekIndicator: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @Query private var records: [DailyRecordModel]
    @Binding var opacity: [Double]
    private let mode: WeekIndicatorMode
    
    init(mode: WeekIndicatorMode = .none, opacity: Binding<[Double]> = Binding(get: { Array(repeating: 0, count: 7) }, set: { _ in })) {
        self.mode = mode
        self._opacity = opacity
    }
    
    init(mode: WeekIndicatorMode, currentDate: Date) {
        self.mode = mode
        self._opacity = Binding(get: { Array(repeating: 0, count: 7) }, set: { _ in })
        _records = Query(DailyCalendarViewModel.recordsForWeekDescriptor(currentDate))
    }
    
    private var ratings: [Double] {
        let calendar = Calendar.current
        var ratings: [Double] = Array(repeating: 0.0, count: 7)
        
        for record in records {
            if let dayIndex = calendar.dateComponents([.weekday], from: record.date).weekday {
                let index = dayIndex - 1
                if record.isSuccess { ratings[index] += 1 }
            }
        }
        
        let recordsByDay = Dictionary(grouping: records) { record -> Int in
            calendar.dateComponents([.weekday], from: record.date).weekday! - 1
        }
        
        for (index, totalRecords) in recordsByDay {
            ratings[index] = ratings[index] / Double(totalRecords.count)
        }
        
        return ratings
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
                        .foregroundStyle(Colors.daily.opacity(mode == .change ? ratings[dayOfWeek.index] * 0.8 : opacity[dayOfWeek.index]))
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
