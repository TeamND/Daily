//
//  String+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

// MARK: - Date
extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }
    
    func toDateOfSetTime() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: self)!
    }
}
