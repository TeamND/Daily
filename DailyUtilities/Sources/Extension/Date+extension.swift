//
//  Date+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

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
        Calendar.current.component(.weekOfMonth, from: self)
    }
    public var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
