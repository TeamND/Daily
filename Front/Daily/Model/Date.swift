//
//  Date.swift
//  Daily
//
//  Created by 최승용 on 2022/12/07.
//

import Foundation

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
    
//    public var getYear: String {
//        let df = DateFormatter()
//        df.dateFormat = "YYYY년"
//        return df.string(from: self)
//    }
//
//    public var getMonth: String {
//        let df = DateFormatter()
//        df.dateFormat = "M월"
//        return df.string(from: self)
//    }
//
//    public var getDay: String {
//        let df = DateFormatter()
//        df.dateFormat = "d일"
//        return df.string(from: self)
//    }
    
    public func getDOW(language: String) -> String {
        return language == "한국어" ? self.getKoreaDOW() : self.getEnglishDOW()
    }

    public func getKoreaDOW() -> String {
        let df = DateFormatter()
        df.dateFormat = "EEE"
        df.locale = Locale(identifier:"ko_KR")
        return df.string(from: self)
    }
    
    public func getEnglishDOW() -> String {
        let df = DateFormatter()
        df.dateFormat = "EEE"
        df.locale = Locale(identifier:"en_KR")
        return df.string(from: self)
    }
    
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
}

extension Date {
    func toString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: self)
    }
}


extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
