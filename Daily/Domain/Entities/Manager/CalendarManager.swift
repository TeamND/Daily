//
//  CalendarManager.swift
//  Daily
//
//  Created by seungyooooong on 2/24/25.
//

import Foundation

final class CalendarManager {
    static let shared = CalendarManager()
    
    private var calendar = Calendar.current
    
    private init() {
        calendar.timeZone = .current
    }
    
    func getDailyCalendar() -> Calendar {
        return calendar
    }
}
