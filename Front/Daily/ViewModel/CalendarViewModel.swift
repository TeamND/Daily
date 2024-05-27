//
//  CalendarViewModel.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import Foundation
import WidgetKit

class CalendarViewModel: ObservableObject {
    // MARK: - year
    @Published var ratingOnYear: [[Double]] = Array(repeating: Array(repeating: 0, count: 31), count: 12)
    @Published var ratingOnYearList: [[[Double]]] = Array(repeating: Array(repeating: Array(repeating: 0, count: 31), count: 12), count: listSize)
    
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
    @Published var daysOnMonth: [dayOnMonthModel] = Array(repeating: dayOnMonthModel(), count: 42)
    @Published var daysOnMonthList: [[dayOnMonthModel]] = Array(repeating: Array(repeating: dayOnMonthModel(), count: 42), count: listSize)
    
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
    @Published var ratingOnWeek: [Double] = Array(repeating: 0.0, count: 7)
    @Published var ratingOnWeekForCharts: [RatingOnWeekModel] = [
        RatingOnWeekModel(day: "일", rating: 0),
        RatingOnWeekModel(day: "월", rating: 0),
        RatingOnWeekModel(day: "화", rating: 0),
        RatingOnWeekModel(day: "수", rating: 0),
        RatingOnWeekModel(day: "목", rating: 0),
        RatingOnWeekModel(day: "금", rating: 0),
        RatingOnWeekModel(day: "토", rating: 0)
        ]
    @Published var ratingOfWeek: Double = 0.0
    @Published var recordsOnWeek: [RecordModel] = []
    @Published var recordsOnWeekList: [[RecordModel]] = Array(repeating: [], count: listSize)
    
    func getRatingOnWeek() -> [Double] {
        return self.ratingOnWeek
    }
    func getDayOfRatingOnWeek(dayIndex: Int) -> Double {
        return self.ratingOnWeek[dayIndex]
    }
    func setRatingOnWeek(ratingOnWeek: [Double], ratingOfWeek: Double) {
        DispatchQueue.main.async {
            self.ratingOnWeek = ratingOnWeek
            for i in ratingOnWeek.indices{
                self.ratingOnWeekForCharts[i].rating = ratingOnWeek[i] * 100
            }
            self.ratingOfWeek = ratingOfWeek * 100
        }
    }
    func setDayOfRatingOnWeek(dayIndex: Int, dayOfRating: Double) {
        DispatchQueue.main.async {
            self.ratingOnWeek[dayIndex] = dayOfRating
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
    @Published var currentStartDay: Int = 0
    @Published var currentDay: Int = Date().day
    
    func getCurrentState() -> String {
        return self.currentState
    }
    func setCurrentState(state: String) {
        DispatchQueue.main.async {
            self.currentState = state
        }
    }
    func setCurrentState(state: String, year: Int, month: Int, day: Int, userInfoViewModel: UserInfoViewModel) {
        DispatchQueue.main.async {
            let currentYear = year == 0 ? self.currentYear : year
            let currentMonth = month == 0 ? self.currentMonth : month
            let currentDay = day == 0 ? self.currentDay : day
            
            switch(state) {
            case "year":
                getCalendarYear(userID: String(userInfoViewModel.userInfo.uid), year: self.getStringFormatOfDate(year: currentYear)) { (data) in
//                    if data.code == "00" {
                        self.setRatingOnYear(ratingOnYear: data.data)
                        self.setCurrentState(state: state)
                        self.setCurrentYear(year: currentYear)
//                    } else {
//                        print("getCalendarYear error... code is \(data.code) = 99")
//                    }
                }
                break
            case "month":
                getCalendarMonth(userID: String(userInfoViewModel.userInfo.uid), month: self.getStringFormatOfDate(year: currentYear, month: currentMonth)) { (data) in
                    self.setDaysOnMonth(daysOnMonth: data.data)
                    self.setCurrentState(state: state)
                    self.setCurrentMonth(month: currentMonth)
                }
                break
            default: // "week"
                let currentDate = self.getStringFormatOfDate(year: currentYear, month: currentMonth, day: currentDay).toDate()!
                let DOW = currentDate.getDOW(language: userInfoViewModel.language)
                var DOWIndex = 0
                for i in userInfoViewModel.weeks.indices {
                    if userInfoViewModel.weeks[i] == DOW { DOWIndex = i }
                }
                var cal = Calendar.current
                cal.timeZone = TimeZone(identifier: "UTC")!
                let startDate = cal.date(byAdding: .day, value: -DOWIndex, to: currentDate)!
                if self.currentStartDay != startDate.day {
                    getCalendarWeek(userID: String(userInfoViewModel.userInfo.uid), startDay: self.getStringFormatOfDate(year: startDate.year, month: startDate.month, day: startDate.day)) { (data) in
                        self.setRatingOnWeek(ratingOnWeek: data.data.rating, ratingOfWeek: data.data.ratingOfWeek)
                        self.setCurrentStartDay(startDay: startDate.day)
                    }
                }
                getCalendarDay(userID: String(userInfoViewModel.userInfo.uid), day: self.getStringFormatOfDate(year: currentYear, month: currentMonth, day: currentDay)) { (data) in
                    self.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
                    self.setCurrentState(state: state)
                    self.setCurrentDay(day: currentDay)
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
    func setCurrentStartDay(startDay: Int) {
        DispatchQueue.main.async {
            self.currentStartDay = startDay
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
    
    func changeCalendar(amount: Int, userInfoViewModel: UserInfoViewModel, targetDate: Date? = nil) {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        var changedDay = Date()
        switch(self.currentState) {
        case "year":
            self.resetRatingOnYear()
            changedDay = cal.date(byAdding: .year, value: amount, to: self.getCurrentDate())!
            getCalendarYear(userID: String(userInfoViewModel.userInfo.uid), year: self.getStringFormatOfDate(year: changedDay.year)) { (data) in
                self.setRatingOnYear(ratingOnYear: data.data)
                self.changeDay(changedDay: changedDay)
            }
            break
        case "month":
            self.resetDaysOnMonth()
            changedDay = cal.date(byAdding: .month, value: amount, to: self.getCurrentDate())!
            getCalendarMonth(userID: String(userInfoViewModel.userInfo.uid), month: self.getStringFormatOfDate(year: changedDay.year, month: changedDay.month)) { (data) in
                self.setDaysOnMonth(daysOnMonth: data.data)
                self.changeDay(changedDay: changedDay)
            }
            break
        default: // "week"
            if amount == 0 { WidgetCenter.shared.reloadAllTimelines() } // update event 발생 시 위젯 동기화
            changedDay = targetDate ?? cal.date(byAdding: .day, value: amount, to: self.getCurrentDate())!
            let DOW = changedDay.getDOW(language: userInfoViewModel.language)
            var DOWIndex = 0
            for i in userInfoViewModel.weeks.indices {
                if userInfoViewModel.weeks[i] == DOW { DOWIndex = i }
            }
            let startDate = cal.date(byAdding: .day, value: -DOWIndex, to: changedDay)!
            if self.currentStartDay != startDate.day || amount == 0 {
                getCalendarWeek(userID: String(userInfoViewModel.userInfo.uid), startDay: self.getStringFormatOfDate(year: startDate.year, month: startDate.month, day: startDate.day)) { (data) in
                    self.setRatingOnWeek(ratingOnWeek: data.data.rating, ratingOfWeek: data.data.ratingOfWeek)
                    self.setCurrentStartDay(startDay: startDate.day)
                }
            }
            getCalendarDay(userID: String(userInfoViewModel.userInfo.uid), day: self.getStringFormatOfDate(year: changedDay.year, month: changedDay.month, day: changedDay.day)) { (data) in
                self.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
                self.changeDay(changedDay: changedDay)
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
    
    func getStringFormatOfDate(year: Int = 0, month: Int = 0, day: Int = 0) -> String {
        if month == 0 {
            return "\(String(format: "%04d", year))"
        } else if day == 0 {
            return "\(String(format: "%04d", year))-\(String(format: "%02d", month))"
        } else {
            return "\(String(format: "%04d", year))-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
        }
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
