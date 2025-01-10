//
//  Date+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

// MARK: - return Int
extension Date {
    public var year: Int {
        Calendar.current.component(.year, from: self)
    }
    public var month: Int {
        Calendar.current.component(.month, from: self)
    }
    public var day: Int {
         Calendar.current.component(.day, from: self)
    }
    public var weekOfMonth: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = (UserDefaultManager.startDay ?? 0) + 1
        return calendar.component(.weekOfMonth, from: self)
    }
    public var weekday: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = (UserDefaultManager.startDay ?? 0) + 1
        return calendar.component(.weekday, from: self)
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
    func toStringOfSetTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    func getSelection(type: CalendarType = .day) -> String {
        switch type {
        case .year:
            return CalendarServices.shared.formatDateString(year: self.year)
        case .month:
            return CalendarServices.shared.formatDateString(year: self.year, month: self.month)
        case .day:
            return CalendarServices.shared.formatDateString(year: self.year, month: self.month, day: self.day)
        }
    }
}

// MARK: - return Date
extension Date {
    func setDefaultEndDate() -> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal.date(byAdding: .month, value: 1, to: self)!
    }
    func startOfDay() -> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal.startOfDay(for: self)
    }
}
