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
    
    func startDayIndex(year: Int = 0, month: Int = 0) -> Int {
        let monthStr = String(format: "%02d", month)
        let startDay = "\(String(year))-\(monthStr)-01".toDate()!
        let startDOW = startDay.getDOW(language: "한국어")
        let dow = DayOfWeek.allCases.filter({ $0.text == startDOW }).first!
        return dow.index
    }
    func lengthOfMonth(year: Int = 0, month: Int = 0) -> Int {
        let monthStr = String(format: "%02d", month)
        return "\(String(year))-\(monthStr)-01".toDate()!.lastDayOfMonth().day
    }
}
