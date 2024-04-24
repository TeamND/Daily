//
//  CalendarViewModel.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import Foundation

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
    @Published var recordsOnWeek: [RecordModel] = []
    @Published var recordsOnWeekList: [[RecordModel]] = Array(repeating: [], count: listSize)
    
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
    func changeCalendar(amount: Int) {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        var changedDay = Date()
//        let value = direction == "prev" ? -amount : +amount
        switch (self.currentState) {
//        case "year":
//            calendarViewModel.resetRatingOnYear()
//            changedDay = cal.date(byAdding: .year, value: value, to: self.currentDate)!
//            break
//        case "month":
//            calendarViewModel.resetDaysOnMonth()
//            changedDay = cal.date(byAdding: .month, value: value, to: self.currentDate)!
//            break
//        case "week":
//            changedDay = cal.date(byAdding: .day, value: value, to: self.currentDate)!
//            break
        default:
            print("changeCalendar currentState error")
        }
//        
//        DispatchQueue.main.async {
//            self.currentYear = changedDay.year
//            self.currentMonth = changedDay.month
//            if self.currentState == "week" {
//                self.currentDay = changedDay.day
//            } else if self.currentState == "month" && changedDay.month == Date().month {
//                self.currentDay = Date().day
//            } else {
//                self.currentDay = 1
//            }
//        }
    }
}
