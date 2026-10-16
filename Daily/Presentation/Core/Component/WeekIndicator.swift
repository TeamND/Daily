//
//  WeekIndicator.swift
//  Daily
//
//  Created by seungyooooong on 4/26/25.
//

import SwiftUI

struct WeekIndicator: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    let mode: WeekIndicatorModes
    
    var body: some View {
        let selection = calendarViewModel.currentDate.getSelection(type: .week)
        HStack(spacing: GeneralServices.daySpacing) {
            ForEach(.zero ..< GeneralServices.week, id: \.self) { index in
                DayOfWeekView(selection: selection, index: index).frame(minWidth: 33)
            }
        }
        .padding(.horizontal, 2)
        .onAppear {
            calendarViewModel.fetchWeekData(selection: selection)
        }
        .onChange(of: selection) { _, selection in
            calendarViewModel.fetchWeekData(selection: selection)
        }
    }
    
    private func DayOfWeekView(selection: String, index: Int) -> some View {
        let startDay = UserDefaultManager.startDay?.index ?? 0
        let dayOfWeek = DayOfWeek.allCases[(index + startDay) % GeneralServices.week]
        
        let isSunday = dayOfWeek.index == 0
        let isNow = calendarViewModel.currentDate.weekday == dayOfWeek.index + 1
        let date = selection.toDate()?.dayLater(value: index) ?? Date(format: .daily)
        
        return VStack(spacing: 6) {
            Text(dayOfWeek.txt)
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
        .frame(maxWidth: .infinity)
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
