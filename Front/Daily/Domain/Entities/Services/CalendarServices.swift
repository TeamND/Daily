//
//  CalendarServices.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

class CalendarServices {
    static let shared = CalendarServices()
    private init() { }
    
    func isToday(year: Int, month: Int, day: Int) -> Bool {
        return Date().year == year && Date().month == month && Date().day == day
    }
    func isSelectedDay(dowIndex: Int, weekSelection: String, daySelection: String) -> Bool {
        return dowIndex == Calendar.current.dateComponents([.day], from: weekSelection.toDate()!, to: daySelection.toDate()!).day!
    }
    
    func formatDateString(year: Int, month: Int = 0, day: Int = 0, joiner: DateJoiner = .hyphen, hasSpacing: Bool = false, hasLastJoiner: Bool = false) -> String {
        let y = year.formatDateString(type: .year)
        let yj = month > 0 || (hasLastJoiner && month == 0) ? joiner.joinString(type: .year, hasSpacing: hasSpacing) : ""
        let m = month.formatDateString(type: .month)
        let mj = day > 0 || (hasLastJoiner && day == 0) ? joiner.joinString(type: .month, hasSpacing: hasSpacing) : ""
        let d = day.formatDateString(type: .day)
        let dj = hasLastJoiner ? joiner.joinString(type: .day, hasSpacing: hasSpacing) : ""
        return month == 0 ? y + yj : day == 0 ? y + yj + m + mj : y + yj + m + mj + d + dj
    }
    func startDayIndex(year: Int = 2000, month: Int = 1) -> Int {
        let startDay = "\(String(year))-\(month.formatDateString(type: .month))-01".toDate()!
        let startDOW = startDay.getDOW(language: "한국어")
        let dow = DayOfWeek.allCases.filter({ $0.text == startDOW }).first!
        return dow.index
    }
    func lengthOfMonth(year: Int = 0, month: Int = 0) -> Int {
        let monthStr = String(format: "%02d", month)
        return "\(String(year))-\(monthStr)-01".toDate()!.lastDayOfMonth().day
    }
    
    func weekSelection(daySelection: String) -> String {
        let date = daySelection.toDate()!
        let dow = DayOfWeek.allCases.filter({ $0.text == date.getDOW(language: "한국어") }).first!
        
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let startDate = cal.date(byAdding: .day, value: -dow.index, to: date)!
        
        let weekSelection = self.formatDateString(year: startDate.year, month: startDate.month, day: startDate.day)
        return weekSelection
    }
    
    func getDate(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        return Calendar.current.date(from: components)
    }
}
