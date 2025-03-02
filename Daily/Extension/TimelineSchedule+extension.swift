//
//  TimelineSchedule+extension.swift
//  Daily
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation
import SwiftUI

extension TimelineSchedule where Self == EveryDay {
    static var everyDay: Self { .init() }
}

struct EveryDay: TimelineSchedule {
    typealias Entries = AnyIterator<Date>
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> Entries {
        var currentDate = Calendar.current.startOfDay(for: startDate)
        
        return AnyIterator {
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            defer { currentDate = nextDate ?? currentDate }
            return currentDate
        }
    }
}
