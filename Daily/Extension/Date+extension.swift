//
//  Date+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

extension Date {
    init(format: DateFormats = .daily, timeZone: TimeZone = .current) {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = timeZone
        
        self = formatter.date(from: formatter.string(from: Date())) ?? Date()
    }
}

// MARK: - return Int
extension Date {
    public func dailyWeekOfMonth(startDay: Int) -> Int {
        var calendar: Calendar = CalendarManager.shared.getDailyCalendar()
        calendar.firstWeekday = startDay + 1
        return calendar.component(.weekOfMonth, from: self)
    }
    public func dailyWeekday(startDay: Int) -> Int {
        (self.weekday - 1 - startDay + GeneralServices.week) % GeneralServices.week
    }
}

// MARK: - return String
extension Date {
    func toString(format: DateFormats = .daily) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    func getSelection(type: CalendarTypes = .day) -> String {
        switch type {
        case .year:
            return CalendarServices.shared.formatDateString(year: self.year)
        case .month:
            return CalendarServices.shared.formatDateString(year: self.year, month: self.month)
        case .week:
            let calendar = CalendarManager.shared.getDailyCalendar()
            let weekday = self.dailyWeekday(startDay: UserDefaultManager.startDay ?? 0)
            let startDate = calendar.date(byAdding: .day, value: -weekday, to: self) ?? Date()
            return CalendarServices.shared.formatDateString(year: startDate.year, month: startDate.month, day: startDate.day)
        case .day:
            return CalendarServices.shared.formatDateString(year: self.year, month: self.month, day: self.day)
        }
    }
}

// MARK: - return Date
extension Date {
    func monthLater(value: Int = 1) -> Date {
        var calendar: Calendar = CalendarManager.shared.getDailyCalendar()
        return calendar.date(byAdding: .month, value: value, to: self)!
    }
    func dayLater(value: Int = 1) -> Date {
        var calendar: Calendar = CalendarManager.shared.getDailyCalendar()
        return calendar.date(byAdding: .day, value: value, to: self)!
    }
}
