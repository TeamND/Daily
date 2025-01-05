//
//  CalendarDayView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI
import SwiftData

// MARK: - CalendarDayView
struct CalendarDayView: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            DailyCalendarHeader(type: .day)
            DailyWeekIndicator(mode: .change, currentDate: dailyCalendarViewModel.currentDate)
            CustomDivider(color: Colors.reverse, height: 2, hPadding: CGFloat.fontSize * 2)
            Spacer().frame(height: CGFloat.fontSize)
            TabView(selection: dailyCalendarViewModel.bindSelection(type: .day)) {
                ForEach(-1 ... 7, id: \.self) { index in
                    let (date, direction, selection) = dailyCalendarViewModel.getCalendarInfo(type: .day, index: index)
                    Group {
                        if direction == .current { CalendarDay(date: date) }
                        else { CalendarLoadView(type: .day, direction: direction) }
                    }
                    .tag(selection)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, CGFloat.fontSize)
            .background(Colors.theme)
        }
        .overlay {
            DailyAddGoalButton()
        }
    }
}
// MARK: - CalendarDay
struct CalendarDay: View {
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @Query private var records: [DailyRecordModel]
    let date: Date
    
    init(date: Date) {
        self.date = date
        _records = Query(DailyCalendarViewModel.recordsForDateDescriptor(date))
    }
    
    var body: some View {
        if records.count == 0 {
            DailyNoRecord()
        } else {
            VStack {
                ViewThatFits(in: .vertical) {
                    DailyRecordList(date: date, records: records)
                    ScrollView {
                        DailyRecordList(date: date, records: records)
                    }
                }
                Spacer().frame(height: CGFloat.fontSize * 15)
                Spacer()
            }
        }
    }
}

#Preview {
    CalendarDayView()
}
