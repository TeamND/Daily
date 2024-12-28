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
    private var updateable: Bool = true
    private var calendar = Calendar.current

    @Published var currentDate: Date = Date()
    
    var decade: Int { currentDate.year / 10 * 10 }
    
    
    
    var currentYear: Int = Date().year
    var currentMonth: Int = Date().month
    var currentDay: Int = Date().day

    // TODO: 추후 삭제
    @Published var yearSelections: [String] = []
    @Published var monthSelections: [String] = []
    @Published var daySelections: [String] = []
    func loadSelections(type: CalendarType, newDate: Date = Date()) {
        currentYear = newDate.year
        currentMonth = newDate.month
        currentDay = newDate.day
        guard let currentDate = CalendarServices.shared.getDate(year: currentYear, month: currentMonth, day: currentDay) else { return }
        switch type {
        case .year:
            yearSelections = (-2 ... 2).map { offset in
                guard let newDate = calendar.date(byAdding: .year, value: offset, to: currentDate) else { return "" }
                return CalendarServices.shared.formatDateString(year: newDate.year)
            }
        case .month:
            monthSelections = (-2 ... 2).map { offset in
                guard let newDate = calendar.date(byAdding: .month, value: offset, to: currentDate) else { return "" }
                return CalendarServices.shared.formatDateString(year: newDate.year, month: newDate.month)
            }
        case .day:
            daySelections = (-2 ... 2).map { offset in
                guard let newDate = calendar.date(byAdding: .day, value: offset, to: currentDate) else { return "" }
                return CalendarServices.shared.formatDateString(year: newDate.year, month: newDate.month, day: newDate.day)
            }
        }
    }
    func updateCurrentCalendar(type: CalendarType, selection: String) {
        if updateable {
            setUpdateTimer()
            let selections = CalendarServices.shared.separateSelection(selection)
            if let currentDate = CalendarServices.shared.getDate(year: currentYear, month: currentMonth, day: currentDay),
               let newDate = CalendarServices.shared.getDate(
                year: selections.count > 0 ? selections[0] : currentYear,
                month: selections.count > 1 ? selections[1] : currentMonth,
                day: selections.count > 2 ? selections[2] : currentDay
               ) {
                let diffrence = calendar.dateComponents([.year, .month, .day], from: currentDate, to: newDate)
                if (type == .year && diffrence.year == 1) ||
                    (type == .month && diffrence.month == 1) ||
                    (type == .day && diffrence.day == 1)
                { loadSelections(type: type, newDate: newDate) }
            }
        }
    }
    func checkCurrentCalendar(type: CalendarType, selection: String) {
        let selections = CalendarServices.shared.separateSelection(selection)
        if let currentDate = CalendarServices.shared.getDate(year: currentYear, month: currentMonth, day: currentDay),
           let newDate = CalendarServices.shared.getDate(
            year: selections.count > 0 ? selections[0] : currentYear,
            month: selections.count > 1 ? selections[1] : currentMonth,
            day: selections.count > 2 ? selections[2] : currentDay
           ) {
            if currentDate != newDate { loadSelections(type: type, newDate: newDate) }
        }
    }
    func setUpdateTimer() {
        DispatchQueue.main.async {
            self.updateable = false
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                self.updateable = true
            }
        }
    }
    
//    @Published var yearSelection: String = CalendarServices.shared.formatDateString(year: Date().year) { didSet { print("test") } }
//    @Published var monthSelection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month)
    @Published var weekSelection: String = CalendarServices.shared.weekSelection(daySelection: CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day))
    @Published var daySelection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day)
    
    // TODO: 추후 삭제
    @Published var yearDictionary: [String: [[Double]]] = [
        CalendarServices.shared.formatDateString(year: Date().year)
        : Array(repeating: Array(repeating: 0, count: 31), count: 12)
    ]
    @Published var monthDictionary: [String: [SymbolsOnMonthModel]] = [
        CalendarServices.shared.formatDateString(year: Date().year, month: Date().month)
        : Array(repeating: SymbolsOnMonthModel(), count: 31)
    ]
    @Published var weekDictionary: [String: RatingsOnWeekModel] = [
        CalendarServices.shared.weekSelection(daySelection: CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day))
        : RatingsOnWeekModel()
    ]
    @Published var dayDictionary: [String: GoalListOnDayModel] = [
        CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day)
        : GoalListOnDayModel()
    ]
    
    // MARK: - init
    init() {
        self.calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }
    
    // MARK: - onAppear
    func calendarYearOnAppear(yearSelection: String) {
        updateCurrentCalendar(type: .year, selection: yearSelection)
        Task {
            guard let userID = UserDefaultManager.userID else { return }
            let ratingsOnYear: [[Double]] = try await ServerNetwork.shared.request(.getCalendarYear(userID: userID, year: yearSelection))
            await MainActor.run { self.yearDictionary[yearSelection] = ratingsOnYear }
        }
    }
    func calendarMonthOnAppear(monthSelection: String) {
        updateCurrentCalendar(type: .month, selection: monthSelection)
        Task {
            guard let userID = UserDefaultManager.userID else { return }
            let symbolsOnMonth: [SymbolsOnMonthModel] = try await ServerNetwork.shared.request(.getCalendarMonth(userID: userID, month: monthSelection))
            await MainActor.run { self.monthDictionary[monthSelection] = symbolsOnMonth }
        }
    }
    func calendarDayOnAppear(daySelection: String? = nil) {
        let daySelection = daySelection ?? self.daySelection
        updateCurrentCalendar(type: .day, selection: daySelection)
        Task {
            guard let userID = UserDefaultManager.userID else { return }
            let goalListOnDay: GoalListOnDayModel = try await ServerNetwork.shared.request(.getCalendarDay(userID: userID, day: daySelection))
            await MainActor.run { self.dayDictionary[daySelection] = goalListOnDay }
        }
    }
    // TODO: 추후 개선
    func weekIndicatorOnChange(weekSelection: String? = nil) {
        Task {
            let weekSelection = weekSelection ?? self.weekSelection
            guard let userID = UserDefaultManager.userID else { return }
            let ratingsOnWeek: RatingsOnWeekModel = try await ServerNetwork.shared.request(.getCalendarWeek(userID: userID, startDay: weekSelection))
            await MainActor.run { withAnimation { self.weekDictionary[weekSelection] = ratingsOnWeek } }
        }
    }
    
    // MARK: - get
    func getDate(type: CalendarType) -> Int {
        let dateComponents = self.daySelection.split(separator: DateJoiner.hyphen.rawValue).compactMap { Int($0) }
        switch type {
        case .year:
            return dateComponents[0]
        case .month:
            return dateComponents[1]
        case .day:
            return dateComponents[2]
        }
    }
    
    // MARK: - set
    func setDate(_ year: Int, _ month: Int, _ day: Int) {
//        self.yearSelection = CalendarServices.shared.formatDateString(year: year)
//        self.monthSelection = CalendarServices.shared.formatDateString(year: year, month: month)
        self.daySelection = CalendarServices.shared.formatDateString(year: year, month: month, day: day)
        self.weekSelection = CalendarServices.shared.weekSelection(daySelection: daySelection)
    }
    
    func loadText(type: CalendarType, direction: Direction) -> String {
        switch type {
        case .year:
            let decade = self.decade + direction.value * 10
            return "\(String(decade))년대"
        case .month:
            let newYear = self.currentDate.year + direction.value
            let newMonth = direction == .next ? 1 : 12
            return "\(String(newYear))년 \(newMonth)월"
        case .day:
            return ""
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
        guard let today = self.daySelection.toDate() else { return }
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let componentType: Calendar.Component
        switch type {
        case .year:
            componentType = .year
        case .month:
            componentType = .month
        case .day:
            componentType = .day
        }
        
        if let prevDate = cal.date(byAdding: componentType, value: direction.value, to: today) {
            self.setDate(prevDate.year, prevDate.month, prevDate.day)
        }
    }
    
    // MARK: - weekIndicator func
    func tapWeekIndicator(dayOfWeek: DayOfWeek) {
        let startDate = self.weekSelection.toDate()!
        let date = calendar.date(byAdding: .day, value: dayOfWeek.index, to: startDate)!
        self.setDate(date.year, date.month, date.day)
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
