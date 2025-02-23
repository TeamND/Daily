//
//  DailyWeekIndicator.swift
//  Daily
//
//  Created by seungyooooong on 10/26/24.
//

import SwiftUI
import SwiftData

struct DailyWeekIndicator: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @Query private var records: [DailyRecordModel]
    @Binding var opacity: [Double]
    private let mode: WeekIndicatorMode
    @AppStorage(UserDefaultKey.startDay.rawValue) var startDay: Int = 0
    
    init(mode: WeekIndicatorMode = .none, opacity: Binding<[Double]> = Binding(get: { Array(repeating: .zero, count: GeneralServices.week) }, set: { _ in })) {
        self.mode = mode
        self._opacity = opacity
    }
    
    init(mode: WeekIndicatorMode, currentDate: Date) {
        self.mode = mode
        self._opacity = Binding(get: { Array(repeating: .zero, count: GeneralServices.week) }, set: { _ in })
        _records = Query(CalendarViewModel.recordsForWeekDescriptor(currentDate))
    }
    
    private var ratings: [Double] {
        var ratings: [Double] = Array(repeating: .zero, count: GeneralServices.week)
        
        for record in records {
            if record.isSuccess { ratings[record.date.dailyWeekday(startDay: startDay)] += 1 }   // TODO: 아직 한 발 남았다
        }
        
        let recordsByDay = Dictionary(grouping: records) { record -> Int in
            record.date.dailyWeekday(startDay: startDay)
        }
        
        for (index, totalRecords) in recordsByDay {
            ratings[index] = ratings[index] / Double(totalRecords.count)
        }
        
        return ratings
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< GeneralServices.week, id: \.self) { index in
                let dayOfWeek = DayOfWeek.allCases[(index + startDay) % GeneralServices.week]
                ZStack {
                    let isSelectedDay = calendarViewModel.currentDate.weekday == dayOfWeek.index + 1
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                        .opacity(isSelectedDay && mode == .change ? 1 : 0)
                        .padding(CGFloat.fontSize / 3)
                    Image(systemName: "circle.fill")
                        .font(.system(size: CGFloat.fontSize * 5))
                        .foregroundStyle(Colors.daily.opacity(mode == .change ? ratings[index] * 0.8 : opacity[index]))
                    Text(dayOfWeek.text)
                        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                }
                .onTapGesture {
                    switch mode {
                    case .change:
                        calendarViewModel.setDate(byAdding: .day, value: index - calendarViewModel.currentDate.dailyWeekday(startDay: startDay))
                    case .select:
                        withAnimation {
                            opacity[index] = opacity[index] == 0.8 ? 0 : 0.8
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
