//
//  CalendarViewModel.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import Foundation

class CalendarViewModel: ObservableObject {
    // MARK: - year
    @Published var beforeYear: Int = 0
    @Published var ratingOnYear: [[Double]] = Array(repeating: Array(repeating: 0, count: 31), count: 12)
    @Published var ratingOnYearList: [[[Double]]] = Array(repeating: Array(repeating: Array(repeating: 0, count: 31), count: 12), count: listSize)
    
    func syncBeforeYear() {
        DispatchQueue.main.async {
            self.beforeYear = self.currentYear
        }
    }
    func getDayOfRatingOnYear(monthIndex: Int, dayIndex: Int) -> Double {
        return self.ratingOnYear[monthIndex][dayIndex]
    }
    func setRatingOnYear(ratingOnYear: [[Double]]) {
        DispatchQueue.main.async {
            self.ratingOnYear = ratingOnYear
        }
    }
    func resetRatingOnYear() {
        self.setRatingOnYear(ratingOnYear: Array(repeating: Array(repeating: 0, count: 31), count: 12))
    }
    
    // MARK: - month
    @Published var beforeMonth: Int = 0
    @Published var daysOnMonth: [dayOnMonthModel] = Array(repeating: dayOnMonthModel(), count: 42)
    @Published var daysOnMonthList: [[dayOnMonthModel]] = Array(repeating: Array(repeating: dayOnMonthModel(), count: 42), count: listSize)
    
    func syncBeforeMonth() {
        DispatchQueue.main.async {
            self.beforeMonth = self.currentMonth
        }
    }
    func getDaysOnMonth(dayIndex: Int) -> dayOnMonthModel {
        return self.daysOnMonth[dayIndex]
    }
    func setDaysOnMonth(daysOnMonth: [dayOnMonthModel]) {
        DispatchQueue.main.async {
            self.daysOnMonth = daysOnMonth
        }
    }
    func resetDaysOnMonth() {
        self.setDaysOnMonth(daysOnMonth: Array(repeating: dayOnMonthModel(), count: 42))
    }
    
    // MARK: - week
    @Published var beforeStartDay: Int = 0
    @Published var ratingOnWeek: [Double] = Array(repeating: 0.0, count: 7)
    @Published var beforeDay: Int = 0
    @Published var recordsOnWeek: [RecordModel] = []
    @Published var recordsOnWeekList: [[RecordModel]] = Array(repeating: [], count: listSize)
    
    func syncBeforeStartDay(currentStartDay: Int) {
        DispatchQueue.main.async {
            self.beforeStartDay = currentStartDay
        }
    }
    func getRatingOnWeek() -> [Double] {
        return self.ratingOnWeek
    }
    func getDayOfRatingOnWeek(dayIndex: Int) -> Double {
        return self.ratingOnWeek[dayIndex]
    }
    func setRatingOnWeek(ratingOnWeek: [Double]) {
        DispatchQueue.main.async {
            self.ratingOnWeek = ratingOnWeek
        }
    }
    func setDayOfRatingOnWeek(dayIndex: Int, dayOfRating: Double) {
        DispatchQueue.main.async {
            self.ratingOnWeek[dayIndex] = dayOfRating
        }
    }
    func syncBeforeDay() {
        DispatchQueue.main.async {
            self.beforeDay = self.currentDay
        }
    }
    func getRecordsOnWeek() -> [RecordModel] {
        return self.recordsOnWeek
    }
    func setRecordsOnWeek(recordsOnWeek: [RecordModel]) {
        DispatchQueue.main.async {
            self.recordsOnWeek = recordsOnWeek
        }
    }

    // MARK: - calendar
    @Published var currentState: String = "month"
    @Published var currentYear: Int = Date().year
    @Published var currentMonth: Int = Date().month
    @Published var currentDay: Int = Date().day
    func getCurrentState() -> String {
        return self.currentState
    }
    func setCurrentState(state: String) {
        DispatchQueue.main.async {
            self.currentState = state
        }
    }
    func setCurrentState(state: String, userInfoViewModel: UserInfoViewModel) {
        DispatchQueue.main.async {
            switch(state) {
            case "year":
                if self.beforeYear != self.currentYear {
                    getCalendarYear(userID: String(userInfoViewModel.userInfo.uid), year: self.getCurrentYearStr()) { (data) in
                        self.setRatingOnYear(ratingOnYear: data.data)
                        self.setCurrentState(state: state)
                        self.syncBeforeYear()
                    }
                }
                break
            case "month":
                if self.beforeYear != self.currentYear || self.beforeMonth != self.currentMonth {
                    getCalendarMonth(userID: String(userInfoViewModel.userInfo.uid), month: "\(self.getCurrentYearStr())-\(self.getCurrentMonthStr())") { (data) in
                        self.setDaysOnMonth(daysOnMonth: data.data)
                        self.setCurrentState(state: state)
                        self.syncBeforeMonth()
                    }
                }
                break
            default: // "week"
                let startDay = self.getStartDay(value: -self.getDOWIndex(userInfoViewModel: userInfoViewModel))
                if self.beforeYear != self.currentYear || self.beforeMonth != self.currentMonth || self.beforeStartDay != startDay {
                    getCalendarWeek(userID: String(userInfoViewModel.userInfo.uid), startDay: self.calcStartDay(value: -self.getDOWIndex(userInfoViewModel: userInfoViewModel))) { (data) in
                        self.setRatingOnWeek(ratingOnWeek: data.data.rating)
                        self.syncBeforeStartDay(currentStartDay: startDay)
                    }
                }
                if self.beforeYear != self.currentYear || self.beforeMonth != self.currentMonth || self.beforeDay != self.currentDay {
                    getCalendarDay(userID: String(userInfoViewModel.userInfo.uid), day: "\(self.getCurrentYearStr())-\(self.getCurrentMonthStr())-\(self.getCurrentDayStr())") { (data) in
                        self.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
                        self.setCurrentState(state: state)
                        self.syncBeforeDay()
                    }
                }
                break
            }
        }
    }
    func getCurrentYear() -> Int {
        return self.currentYear
    }
    func setCurrentYear(year: Int) {
        DispatchQueue.main.async {
            self.currentYear = year
        }
    }
    func getCurrentMonth() -> Int {
        return self.currentMonth
    }
    func setCurrentMonth(month: Int) {
        DispatchQueue.main.async {
            self.currentMonth = month
        }
    }
    func getCurrentDay() -> Int {
        return self.currentDay
    }
    func setCurrentDay(day: Int) {
        DispatchQueue.main.async {
            self.currentDay = day
        }
    }
    func getCurrentYearLabel(userInfoViewModel: UserInfoViewModel) -> String {
        switch(userInfoViewModel.language) {
        case "한국어":
            return "\(String(self.currentYear))년"
        default:
            return "in \(String(self.currentYear))"
        }
    }
    func getCurrentMonthLabel(userInfoViewModel: UserInfoViewModel) -> String {
        return userInfoViewModel.months[self.currentMonth - 1]
    }
    func getCurrentDayLabel(userInfoViewModel: UserInfoViewModel) -> String {
        switch(userInfoViewModel.language) {
        case "한국어":
            return "\(self.currentDay)일"
        default:
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
    func getCurrentYearStr() -> String {
        return String(format: "%04d", self.currentYear)
    }
    func getCurrentMonthStr() -> String {
        return String(format: "%02d", self.currentMonth)
    }
    func getCurrentDayStr() -> String {
        return String(format: "%02d", self.currentDay)
    }
    func getCurrentDate() -> Date {
        return "\(self.getCurrentYearStr())-\(self.getCurrentMonthStr())-\(self.getCurrentDayStr())".toDate()!
    }
    func getCurrentDOW(userInfoViewModel: UserInfoViewModel) -> String {
        return self.getCurrentDate().getDOW(language: userInfoViewModel.language)
    }
    func getDOWIndex(userInfoViewModel: UserInfoViewModel) -> Int {
        for i in userInfoViewModel.weeks.indices {
            if userInfoViewModel.weeks[i] == self.getCurrentDOW(userInfoViewModel: userInfoViewModel) { return i }
        }
        return 0
    }
    
    func isToday(day: Int) -> Bool {
        let today = Date()
        if today.year == self.currentYear && today.month == self.currentMonth {
            return today.day == day
        }
        return false
    }
    
    func changeCalendar(amount: Int, userInfoViewModel: UserInfoViewModel) {
        if amount == 0 { return }
        
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        var changedDay = Date()
        switch(self.currentState) {
        case "year":
            self.resetRatingOnYear()
            changedDay = cal.date(byAdding: .year, value: amount, to: self.getCurrentDate())!
            getCalendarYear(userID: String(userInfoViewModel.userInfo.uid), year: "\(String(format: "%04d", changedDay.year))") { (data) in
                self.setRatingOnYear(ratingOnYear: data.data)
                self.changeDay(changedDay: changedDay)
                self.syncBeforeYear()
            }
            break
        case "month":
            self.resetDaysOnMonth()
            changedDay = cal.date(byAdding: .month, value: amount, to: self.getCurrentDate())!
            getCalendarMonth(userID: String(userInfoViewModel.userInfo.uid), month: "\(String(format: "%04d", changedDay.year))-\(String(format: "%02d", changedDay.month))") { (data) in
                self.setDaysOnMonth(daysOnMonth: data.data)
                self.changeDay(changedDay: changedDay)
                self.syncBeforeMonth()
            }
            break
        default: // "week"
            changedDay = cal.date(byAdding: .day, value: amount, to: self.getCurrentDate())!
            let startDay = self.getStartDay(value: -self.getDOWIndex(userInfoViewModel: userInfoViewModel))
            if self.beforeStartDay != startDay {
                getCalendarWeek(userID: String(userInfoViewModel.userInfo.uid), startDay: self.calcStartDay(value: -self.getDOWIndex(userInfoViewModel: userInfoViewModel))) { (data) in
                    self.setRatingOnWeek(ratingOnWeek: data.data.rating)
                    self.syncBeforeStartDay(currentStartDay: startDay)
                }
            }
            getCalendarDay(userID: String(userInfoViewModel.userInfo.uid), day: "\(String(format: "%04d", changedDay.year))-\(String(format: "%02d", changedDay.month))-\(String(format: "%02d", changedDay.day))") { (data) in
                self.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
                self.changeDay(changedDay: changedDay)
                self.syncBeforeDay()
            }
            break
        }
    }
    
    func changeDay(changedDay: Date) {
        self.setCurrentYear(year: changedDay.year)
        self.setCurrentMonth(month: changedDay.month)
        if self.currentState == "week" {
            self.setCurrentDay(day: changedDay.day)
        } else if self.currentState == "month" && changedDay.month == Date().month {
            self.setCurrentDay(day: Date().day)
        } else {
            self.setCurrentDay(day: 1)
        }
    }
    
    // API 통합 이후 묶어서 추후 수정
    func getStartDay(value: Int) -> Int {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let changedDay = cal.date(byAdding: .day, value: value, to: self.getCurrentDate())!
        
        return changedDay.day
    }
    func calcStartDay(value: Int) -> String {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let changedDay = cal.date(byAdding: .day, value: value, to: self.getCurrentDate())!
        
        return "\(String(format: "%04d", changedDay.year))-\(String(format: "%02d", changedDay.month))-\(String(format: "%02d", changedDay.day))"
    }
    
    func startDayIndex(userInfoViewModel: UserInfoViewModel, month: Int = 0) -> Int {
        let monthStr = String(format: "%02d", month == 0 ? self.currentMonth : month)
        let startDay = "\(self.getCurrentYearStr())-\(monthStr)-01".toDate()!
        for i in userInfoViewModel.weeks.indices {
            if userInfoViewModel.weeks[i] == startDay.getDOW(language: userInfoViewModel.language) { return i }
        }
        return 0
    }
    
    func lengthOfMonth(month: Int = 0) -> Int {
        let monthStr = String(format: "%02d", month == 0 ? self.currentMonth : month)
        return "\(self.getCurrentYearStr())-\(monthStr)-01".toDate()!.lastDayOfMonth().day
    }
}
