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
    
    public func startOfMonth() -> Date {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        
        print(self)
        print(df.string(from: self))
        
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    
    public var monthName: String {
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM" // format January, February, March, ...
        return nameFormatter.string(from: self)
    }
}

//extension Date {
//
//    func startOfMonth() -> Date {
////        let df = DateFormatter()
////        df.locale = Locale(identifier: "ko_KR")
//        print(NSCalendar.current.date(from: NSCalendar.current.dateComponents([.year, .month], from: self))!)
////        print(
////            NSCalendar.current.date(byAdding: DateComponents(day: 1), to:
////            NSCalendar.current.date(from: NSCalendar.current.dateComponents([.year, .month], from: self))!
////            )
////        )
//        return NSCalendar.current.date(from: NSCalendar.current.dateComponents([.year, .month], from: NSCalendar.current.startOfDay(for: self)))!
//    }
//
//    func endOfMonth() -> Date {
//        return NSCalendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
//    }
//}
