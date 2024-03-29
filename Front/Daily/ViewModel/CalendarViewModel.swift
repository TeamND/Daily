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
    
    func getDayOfRatingOnYear(monthIndex: Int, dayIndex: Int) -> Double {
        return self.ratingOnYear[monthIndex][dayIndex]
    }
    func setRatingOnYear(ratingOnYear: [[Double]]) {
        DispatchQueue.main.async {
            self.ratingOnYear = ratingOnYear
        }
    }
    
    // MARK: - month
    @Published var daysOnMonth: [dayOnMonthModel] = Array(repeating: dayOnMonthModel(), count: 42)
    
    func setDaysOnmonth(daysOnMonth: [dayOnMonthModel]) {
        DispatchQueue.main.async {
            self.daysOnMonth = daysOnMonth
        }
    }
    
    // MARK: - week
    @Published var ratingOnWeek: [Double] = Array(repeating: 0.0, count: 7)
    @Published var recordsOnWeek: [RecordModel] = []
    
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
}
