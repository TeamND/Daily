//
//  WeekIndicator.swift
//  Daily
//
//  Created by seungyooooong on 4/26/25.
//

import SwiftUI

struct WeekIndicator: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @AppStorage(UserDefaultKey.startDay.rawValue) var startDay: Int = 0
    
    let mode: WeekIndicatorModes
    let selection: String
    
    init(mode: WeekIndicatorModes, selection: String = "") {
        self.mode = mode
        self.selection = selection
    }
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(.zero ..< GeneralServices.week, id: \.self) { index in
                if .zero < index { Spacer() }
                DayOfWeekView(dayOfWeek: DayOfWeek.allCases[(index + startDay) % GeneralServices.week]).frame(minWidth: 33)
            }
        }
        .padding(.horizontal, 2)
        .onAppear {
            calendarViewModel.fetchWeekData(selection: selection)
        }
        .onChange(of: selection) { _, newValue in
            calendarViewModel.fetchWeekData(selection: newValue)
        }
    }
    
    private func DayOfWeekView(dayOfWeek: DayOfWeek) -> some View {
        let isSunday = dayOfWeek.index == 0
        let isNow = calendarViewModel.currentDate.weekday == dayOfWeek.index + 1
        let date = selection.toDate()?.dayLater(value: dayOfWeek.index) ?? Date(format: .daily)
        
        return VStack(spacing: 6) {
            Text(dayOfWeek.text)
                .font(Fonts.bodySmRegular)
                .foregroundStyle(
                    mode.hasPointText && isNow ? Colors.Text.point :
                        isSunday ? Colors.Brand.holiday :
                        Colors.Text.primary
                )
            if mode == .change {
                TimelineView(.everyDay) { context in
                    let rating = calendarViewModel.weekData[selection]?.ratingsOfWeek[dayOfWeek.index]
                    let isToday = date == context.date
                    let isHoliday = UserDefaultManager.holidays?[date.year]?[date.getSelection()] != nil
                    DayIndicator(
                        day: date.day,
                        rating: rating,
                        isToday: isToday,
                        isHoliday: isSunday || isHoliday,
                        isNow: isNow
                    )
                }
            }
        }
        .onTapGesture {
            switch mode {
            case .change:
                calendarViewModel.setDate(date: date)
            case .select, .none:
                break
            }
        }
    }
}
