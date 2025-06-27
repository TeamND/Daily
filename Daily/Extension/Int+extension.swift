//
//  Int+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

extension Int {
    func timerFormat() -> String {
        return String(format: "%02d:%02d:%02d", self / 3600, self % 3600 / 60, self % 60)
    }
    
    func formatDateString(type: CalendarTypes) -> String {
        switch type {
        case .year:
            return String(format: "%04d", self)
        default:
            return String(format: "%02d", self)
        }
    }
}
