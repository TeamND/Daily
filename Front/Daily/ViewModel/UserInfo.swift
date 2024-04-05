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
    
    init() {
        self.uid = 0
        self.set_startday = 0
        self.set_language = "korea"
        self.set_dateorrepeat = "date"
        self.set_calendarstate = "month"
    }
    
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
//                setUserInfo(param: ["uid": self.uid, "set_startday": 0])
                self.set_startday = 0
            } else {
//                setUserInfo(param: ["uid": self.uid, "set_startday": 1])
                self.set_startday = 1
            }
        }
    }
    var language: String {
        get { return self.set_language == "korea" ? "한국어" : "영어" }
        set(newValue) {
            if newValue == "한국어" {
//                setUserInfo(param: ["uid": self.uid, "set_language": "korea"])
                self.set_language = "korea"
            } else {
//                setUserInfo(param: ["uid": self.uid, "set_language": "english"])
                self.set_language = "english"
            }
        }
    }
    var dateOrRepeat: String {
        get { return self.set_dateorrepeat == "date" ? "날짜" : "반복" }
        set(newValue) {
            if newValue == "날짜" {
//                setUserInfo(param: ["uid": self.uid, "set_dateorrepeat": "date"])
                self.set_dateorrepeat = "date"
            } else {
//                setUserInfo(param: ["uid": self.uid, "set_dateorrepeat": "repeat"])
                self.set_dateorrepeat = "repeat"
            }
        }
    }
    
    var calendarState: String {
        get { return self.set_calendarstate == "year" ? "년" : self.set_calendarstate == "month" ? "월" : "주" }
        set(newValue) {
            if newValue == "년" {
//                setUserInfo(param: ["uid": self.uid, "set_calendarstate": "year"])
                self.set_calendarstate = "year"
            } else if newValue == "월" {
//                setUserInfo(param: ["uid": self.uid, "set_calendarstate": "month"])
                self.set_calendarstate = "month"
            } else {
//                setUserInfo(param: ["uid": self.uid, "set_calendarstate": "week"])
                self.set_calendarstate = "week"
            }
            self.currentState = self.set_calendarstate
            self.currentYear = Date().year
            self.currentMonth = Date().month
            self.currentDay = Date().day
        }
    }
    
    // about current calendar
    @Published var currentState: String = "month"
    @Published var currentYear: Int = Date().year
    @Published var currentMonth: Int = Date().month
    @Published var currentDay: Int = Date().day
    var currentYearLabel: String {
        get {
            if self.set_language == "korea" {
                return "\(String(self.currentYear))년"
            } else {
                return "in \(String(self.currentYear))"
            }
        }
    }
    var currentMonthLabel: String {
        get {
            return self.months[self.currentMonth - 1]
        }
    }
    var currentDayLabel: String {
        get {
            if self.set_language == "korea" {
                return "\(self.currentDay)일"
            } else {
                switch self.currentDay {
                case 1, 21, 31:
                    return "\(self.currentDay)st"
                case 2, 22:
                    return "\(self.currentDay)nd"
                case 3, 23:
                    return "\(self.currentDay)rd"
                default:
                    return "\(self.currentDay)th"
                }
            }
        }
    }
    var currentYearStr: String {
        get {
            return String(format: "%04d", self.currentYear)
        }
    }
    var currentMonthStr: String {
        get {
            return String(format: "%02d", self.currentMonth)
        }
    }
    var currentDayStr: String {
        get {
            return String(format: "%02d", self.currentDay)
        }
    }
    var currentDate: Date {
        get {
            return "\(self.currentYearStr)-\(self.currentMonthStr)-\(self.currentDayStr)".toDate()!
        }
    }
    var currentDOW: String {
        get {
            return self.currentDate.getDOW(language: self.language)
        }
    }
    var DOWIndex: Int {
        get {
            for i in self.weeks.indices {
                if self.weeks[i] == self.currentDOW { return i }
            }
            return 0
        }
    }
}

extension UserInfo {
    func isToday(day: Int) -> Bool {
        let today = Date()
        if today.year == self.currentYear && today.month == self.currentMonth {
            return today.day == day
        }
        return false
    }
    
    func changeCalendar(direction: String, calendarViewModel: CalendarViewModel) {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        var changedDay = Date()
        let value = direction == "prev" ? -1 : +1
        switch (self.currentState) {
        case "year":
            calendarViewModel.resetRatingOnYear()
            changedDay = cal.date(byAdding: .year, value: value, to: self.currentDate)!
            break
        case "month":
            calendarViewModel.resetDaysOnMonth()
            changedDay = cal.date(byAdding: .month, value: value, to: self.currentDate)!
            break
        case "week":
            changedDay = cal.date(byAdding: .day, value: value, to: self.currentDate)!
            break
        default:
            print("changeCalendar currentState error")
        }
        
        DispatchQueue.main.async {
            self.currentYear = changedDay.year
            self.currentMonth = changedDay.month
            self.currentDay = self.currentState == "week" ? changedDay.day : 1
        }
    }
    
    func changeDay(DOWIndex: Int) {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let changedDay = cal.date(byAdding: .day, value: DOWIndex - self.DOWIndex, to: self.currentDate)!
        
        self.currentYear = changedDay.year
        self.currentMonth = changedDay.month
        self.currentDay = changedDay.day
    }
    
    func calcStartDay(value: Int) -> String {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let changedDay = cal.date(byAdding: .day, value: value, to: self.currentDate)!
        
        return "\(String(format: "%04d", changedDay.year))-\(String(format: "%02d", changedDay.month))-\(String(format: "%02d", changedDay.day))"
    }
    
    func startDayIndex(month: Int = 0) -> Int {
        let monthStr = String(format: "%02d", month == 0 ? self.currentMonth : month)
        let startDay = "\(self.currentYearStr)-\(monthStr)-01".toDate()!
        for i in self.weeks.indices {
            if self.weeks[i] == startDay.getDOW(language: self.language) { return i }
        }
        return 0
    }
    
    func lengthOfMonth(month: Int = 0) -> Int {
        let monthStr = String(format: "%02d", month == 0 ? self.currentMonth : month)
        return "\(self.currentYearStr)-\(monthStr)-01".toDate()!.lastDayOfMonth().day
    }
}

extension UserInfo {
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
    
    var months: [String] {
        get {
            if self.set_language == "korea" {
                return ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
            } else {
                return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            }
        }
    }
}
