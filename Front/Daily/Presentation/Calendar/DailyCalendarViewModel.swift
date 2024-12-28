//
//  DailyCalendarViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import SwiftUI
import SwiftData

class DailyCalendarViewModel: ObservableObject {
    private let calendarUseCase: CalendarUseCase
    private var calendar = Calendar.current

    @Published var currentDate: Date = Date()
    
//    var yeardate: Date { calendar.date(byAdding: .year, value: -currentDate.year % 10, to: currentDate) ?? Date() }
//    var monthdate: Date { calendar.date(byAdding: .month , value: -(currentDate.month - 1), to: currentDate) ?? Date() }
//    var weekdate: Date { calendar.date(byAdding: .day, value: -(currentDate.weekday - 1), to: currentDate) ?? Date() }
    
    func getCalendarInfo(type: CalendarType, index: Int) -> (date: Date, direction: Direction, selection: String) {
        let byAdding: Calendar.Component = type == .year ? .year : type == .month ? .month : .day
        let offset: Int = type == .year ? currentDate.year % 10 : type == .month ? (currentDate.month - 1) : (currentDate.weekday - 1)
        let date: Date = calendar.date(byAdding: byAdding, value: index - offset, to: currentDate) ?? Date()
        
        let maxIndex = type == .year ? 10 : type == .month ? 12 : 7
        let direction: Direction = index < 0 ? .prev : index < maxIndex ? .current : .next
        
        return (date, direction, date.getSelection(type: type))
    }
    
    // MARK: - init
    init() {
        self.calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }
    
    func loadText(type: CalendarType, direction: Direction) -> String {
        switch type {
        case .year:
            let decade = (currentDate.year / 10 + direction.value) * 10
            return "\(String(decade))년대"
        case .month:
            let year = currentDate.year + direction.value
            return "\(String(year))년"
        case .day:
            let date = calendar.date(byAdding: .day, value: direction.value, to: currentDate) ?? Date()
            return "\(date.month)월 \(date.weekOfMonth)주차"
        }
    }
    
    // MARK: - header func
    func headerText(type: CalendarType, textPosition: TextPositionInHeader) -> String {
        switch type {
        case .year:
            return textPosition == .title ? String(self.currentDate.year) + "년" : ""
        case .month:
            return textPosition == .title ? String(self.currentDate.month) + "월" : String(self.currentDate.year) + "년"
        case .day:
            return textPosition == .title ? String(self.currentDate.day) + "일" : String(self.currentDate.month) + "월"
        }
    }
    func moveDate(type: CalendarType, direction: Direction) {
//        guard let today = self.daySelection.toDate() else { return }
//        var cal = Calendar.current
//        cal.timeZone = TimeZone(identifier: "UTC")!
//        let componentType: Calendar.Component
//        switch type {
//        case .year:
//            componentType = .year
//        case .month:
//            componentType = .month
//        case .day:
//            componentType = .day
//        }
//        
//        if let prevDate = cal.date(byAdding: componentType, value: direction.value, to: today) {
//            self.setDate(prevDate.year, prevDate.month, prevDate.day)
//        }
    }
    
    // MARK: - weekIndicator func
    func tapWeekIndicator(dayOfWeek: DayOfWeek) {
//        let startDate = self.weekSelection.toDate()!
//        let date = calendar.date(byAdding: .day, value: dayOfWeek.index, to: startDate)!
//        self.setDate(date.year, date.month, date.day)
    }

    // MARK: - Query filter
    func getRecords() -> FetchDescriptor<DailyRecordModel> {
        return FetchDescriptor<DailyRecordModel>()
    }
    func getGoals(year: Int, month: Int, day: Int) -> FetchDescriptor<DailyGoalModel> {
        var descriptor = FetchDescriptor<DailyGoalModel>()
        descriptor.predicate = #Predicate<DailyGoalModel> {
            $0.records.contains(
                where: {
                    $0.isSuccess
//                    let daySelection = CalendarServices.shared.formatDateString(year: year, month: month, day: day)
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd"
//                    dateFormatter.timeZone = TimeZone(identifier: "UTC")
//                    if let date = dateFormatter.date(from: daySelection) {
//                        $0.date == date
//                    } else {
//                        $0.date == Date()
//                    }
                }
            )
        }
        return descriptor
    }
}
