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
        var calendar = Calendar.current
        calendar.firstWeekday = startDay + 1
        return calendar.component(.weekOfMonth, from: self)
    }
    public func dailyWeekday(startDay: Int) -> Int {
        (self.weekday - 1 - startDay + GeneralServices.week) % GeneralServices.week
    }
}

// MARK: - return String
extension Date {
    public func getDOW(language: String) -> String {
        return language == "한국어" ? self.getKoreaDOW() : self.getEnglishDOW()
    }
    public func getKoreaDOW() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        return dateFormatter.string(from: self)
    }
    public func getEnglishDOW() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dateFormatter.locale = Locale(identifier:"en_KR")
        return dateFormatter.string(from: self)
    }
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
        Calendar.current.date(byAdding: .month, value: value, to: self)!
    }
    func dayLater(value: Int = 1) -> Date {
        Calendar.current.date(byAdding: .day, value: value, to: self)!
    }
}
