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
        return Calendar.current.component(.year, from: self)
    }
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    public var day: Int {
         return Calendar.current.component(.day, from: self)
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
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    func toStringOfSetTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    func yyyyMMdd() -> String {
        return String(format: "%04d", self.year) + String(format: "%02d", self.month) + String(format: "%02d", self.day)
    }
}

// MARK: - return Date
extension Date {
    public func startDayOfMonth() -> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal.startOfDay(for: cal.date(from: cal.dateComponents([.year, .month], from: self))!)
    }
    public func startDayOfNextMonth() -> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal.date(byAdding: .month, value: +1, to: self.startDayOfMonth())!
    }
    public func lastDayOfMonth() -> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal.date(byAdding: .day, value: -1, to: self.startDayOfNextMonth())!
    }
    func setDefaultEndDate() -> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal.date(byAdding: .month, value: 1, to: self)!
    }
}
