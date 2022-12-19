//
//  UserInfo.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import Foundation

class UserInfo: ObservableObject{
    @Published var uid: Int
    @Published var set_startday: Int
    @Published var set_language: String
    @Published var set_dateorrepeat: String
    @Published var set_calendarstate: String
    
    init(uid: Int, set_startday: Int, set_language: String, set_dateorrepeat: String, set_calendarstate: String) {
        self.uid = uid
        self.set_startday = set_startday
        self.set_language = set_language
        self.set_dateorrepeat = set_dateorrepeat
        self.set_calendarstate = set_calendarstate
    }
    
    var startDay: String {
        get { return self.weeks[0] }
        set(newValue) {
            if newValue == "일" || newValue == "Sun" {
                setUserInfo(param: ["uid": self.uid, "set_startday": 0])
                self.set_startday = 0
            } else {
                setUserInfo(param: ["uid": self.uid, "set_startday": 1])
                self.set_startday = 1
            }
        }
    }
    var language: String {
        get { return self.set_language == "korea" ? "한국어" : "영어" }
        set(newValue) {
            if newValue == "한국어" {
                setUserInfo(param: ["uid": self.uid, "set_language": "korea"])
                self.set_language = "korea"
            } else {
                setUserInfo(param: ["uid": self.uid, "set_language": "english"])
                self.set_language = "english"
            }
        }
    }
    var dateOrRepeat: String {
        get { return self.set_dateorrepeat == "date" ? "날짜" : "반복" }
        set(newValue) {
            if newValue == "날짜" {
                setUserInfo(param: ["uid": self.uid, "set_dateorrepeat": "date"])
                self.set_dateorrepeat = "date"
            } else {
                setUserInfo(param: ["uid": self.uid, "set_dateorrepeat": "repeat"])
                self.set_dateorrepeat = "repeat"
            }
        }
    }
    
    var calendarState: String {
        get { return self.set_calendarstate == "year" ? "년" : self.set_calendarstate == "month" ? "월" : "주" }
        set(newValue) {
            if newValue == "년" {
                setUserInfo(param: ["uid": self.uid, "set_calendarstate": "year"])
                self.set_calendarstate = "year"
            } else if newValue == "월" {
                setUserInfo(param: ["uid": self.uid, "set_calendarstate": "month"])
                self.set_calendarstate = "month"
            } else {
                setUserInfo(param: ["uid": self.uid, "set_calendarstate": "week"])
                self.set_calendarstate = "week"
            }
        }
    }
    
    @Published var currentState: String = "month"
    @Published var currentYear: Int = Date().year
    @Published var currentMonth: Int = Date().month
    @Published var currentDay: Int = Date().day
    @Published var dayIndex: Int = 0
    
    func isToday(day: Int) -> Bool {
        let today = Date()
        if today.year == self.currentYear && today.month == self.currentMonth {
            return today.day == day
        }
        return false
    }
    
    func changeDay(dayIndex: Int) {
        let yearStr = String(format: "%4d", self.currentYear)
        let monthStr = String(format: "%2d", self.currentMonth)
        let dayStr = String(format: "%2d", self.currentDay)
        let today = "\(yearStr)-\(monthStr)-\(dayStr)".toDate()!
        
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let changedDay = cal.date(byAdding: .day, value: dayIndex - self.dayIndex, to: today)!
        
        self.currentYear = changedDay.year
        self.currentMonth = changedDay.month
        self.currentDay = changedDay.day
        self.dayIndex = dayIndex
    }
    
    func startDayIndex(year: Int = 0, month: Int = 0) -> Int {
        let yearStr = String(format: "%4d", year == 0 ? self.currentYear : year)
        let monthStr = String(format: "%2d", month == 0 ? self.currentMonth : month)
        let startDay = "\(yearStr)-\(monthStr)-01".toDate()!
        let DOW = self.language == "한국어" ? startDay.getKoreaDOW() : startDay.getEnglishDOW()
        for i in self.weeks.indices {
            if self.weeks[i] == DOW { return i }
        }
        return 0
    }
    
    func lengthOfMonth(year: Int = 0, month: Int = 0) -> Int {
        let yearStr = String(format: "%4d", year == 0 ? self.currentYear : year)
        let monthStr = String(format: "%2d", month == 0 ? self.currentMonth : month)
        return "\(yearStr)-\(monthStr)-01".toDate()!.lastDayOfMonth().day
    }
    
    var weeks: [String] {
        get {
            if self.set_language == "korea" {
                if self.set_startday == 0 {
                    return ["일", "월", "화", "수", "목", "금", "토"]
                } else {
                    return ["월", "화", "수", "목", "금", "토", "일"]
                }
            } else {
                if self.set_startday == 0 {
                    return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                } else {
                    return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                }
            }
        }
    }
}
