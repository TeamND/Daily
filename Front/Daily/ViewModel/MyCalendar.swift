//
//  Calendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import Foundation

class MyCalendar: ObservableObject {
    @Published var state: String = "Month"
    @Published var year: Int
    @Published var month: Int
    @Published var day: Int
    @Published var dayIndex: Int
    
    
    init() {
        self.year = Date().year
        self.month = Date().month
        self.day = Date().day
        self.dayIndex = 0
    }
    
    func isToday(day: Int) -> Bool {
        let today = Date()
        if today.year == self.year && today.month == self.month {
            return today.day == day
        }
        return false
    }
    
    func changeDay(dayIndex: Int) {
        let yearStr = String(format: "%4d", self.year)
        let monthStr = String(format: "%2d", self.month)
        let dayStr = String(format: "%2d", self.day)
        let today = "\(yearStr)-\(monthStr)-\(dayStr)".toDate()!
        
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let changedDay = cal.date(byAdding: .day, value: dayIndex - self.dayIndex, to: today)!
        
        self.year = changedDay.year
        self.month = changedDay.month
        self.day = changedDay.day
        self.dayIndex = dayIndex
    }
    
    func startDayIndex(year: Int = 0, month: Int = 0) -> Int {
        let yearStr = String(format: "%4d", year == 0 ? self.year : year)
        let monthStr = String(format: "%2d", month == 0 ? self.month : month)
        return "\(yearStr)-\(monthStr)-01".toDate()!.startDayIndex()
    }
    
    func lengthOfMonth(year: Int = 0, month: Int = 0) -> Int {
        let yearStr = String(format: "%4d", year == 0 ? self.year : year)
        let monthStr = String(format: "%2d", month == 0 ? self.month : month)
        return "\(yearStr)-\(monthStr)-01".toDate()!.lastDayOfMonth().day
    }
}
