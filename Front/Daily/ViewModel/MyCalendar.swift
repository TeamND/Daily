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
    
    init() {
        self.year = Date().year
        self.month = Date().month
        self.day = Date().day
    }
    
    func isToday(day: Int) -> Bool {
        let today = Date()
        if today.year == self.year && today.month == self.month {
            return today.day == day
        }
        return false
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
