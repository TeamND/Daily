//
//  CalendarUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

final class CalendarUseCase {
    private let repository: CalendarInterface
    private let calendar: Calendar = CalendarManager.shared.getDailyCalendar()
    
    init(repository: CalendarInterface) {
        self.repository = repository
    }
}

// MARK: - business logic
extension CalendarUseCase {
    func getLoadText(currentDate: Date, type: CalendarTypes, direction: Direction) -> String {
        switch type {
        case .year:
            let decade = (currentDate.year / 10 + direction.value) * 10
            return "\(String(decade))년대"
        case .month:
            let year = currentDate.year + direction.value
            return "\(String(year))년"
        case .day:
            let date = calendar.date(byAdding: .day, value: direction.value, to: currentDate) ?? Date(format: .daily)
            return "\(date.month)월 \(date.dailyWeekOfMonth(startDay: UserDefaultManager.startDay ?? 0))주차"
        default:
            return ""
        }
    }
    
    func getHeaderText(currentDate: Date, type: CalendarTypes, textPosition: TextPositionInHeader = .title) -> String {
        switch type {
        case .year:
            return textPosition == .title ? String(currentDate.year) + "년" : ""
        case .month:
            return textPosition == .title ? String(currentDate.month) + "월" : String(currentDate.year) + "년"
        case .day:
            return textPosition == .title ? String(currentDate.month) + "월 " + String(currentDate.day) + "일" : String(currentDate.month) + "월"
        default:
            return ""
        }
    }
    
    func getCalendarInfo(currentDate: Date, type: CalendarTypes, index: Int) -> (date: Date, direction: Direction, selection: String) {
        let offset: Int = type == .year ? currentDate.year % 10 : type == .month ? (currentDate.month - 1) : currentDate.dailyWeekday(startDay: UserDefaultManager.startDay ?? 0)
        let date: Date = calendar.date(byAdding: type.byAdding, value: index - offset, to: currentDate) ?? Date(format: .daily)
        
        let maxIndex = type == .year ? 10 : type == .month ? 12 : GeneralServices.week
        let direction: Direction = index < 0 ? .prev : index < maxIndex ? .current : .next
        
        return (date, direction, date.getSelection(type: type))
    }
    
    func getMonthInfo(date: Date) -> (startOfMonthWeekday: Int, lengthOfMonth: Int, dividerCount: Int) {
        let startOfMonth = calendar.date(from: DateComponents(year: date.year, month: date.month, day: 1))!
        let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
        let weekday = startOfMonth.dailyWeekday(startDay: UserDefaultManager.startDay ?? 0)
        let dividerCount = (lengthOfMonth + weekday - 1) / GeneralServices.week
        return (weekday + 1, lengthOfMonth, dividerCount)
    }
}

// MARK: - get records func
extension CalendarUseCase {
    func getYearRecords(selection: String) async -> [DailyRecordModel] {
        await repository.getYearRecords(selection: selection) ?? []
    }
    
    func getMonthRecords(selection: String) async -> [DailyRecordModel] {
        await repository.getMonthRecords(selection: selection) ?? []
    }
    
    func getWeekRecords(selection: String) async -> [DailyRecordModel] {
        await repository.getWeekRecords(selection: selection) ?? []
    }
    
    func getDayRecords(selection: String) async -> [DailyRecordModel] {
        await repository.getDayRecords(selection: selection) ?? []
    }
}

// MARK: - update or delete records func
extension CalendarUseCase {
    func addCount(goal: DailyGoalModel, record: DailyRecordModel) async {
        record.count += 1
        record.isSuccess = record.count >= goal.count
        await repository.updateData()
    }
    
    func toggleStartTime(record: DailyRecordModel) async {
        record.startTime = record.startTime == nil ? Date() : nil
        await repository.updateData()
    }
    
    func updateTimer(record: DailyRecordModel, completeAction: @escaping () -> Void) {
        Task { @MainActor in
            guard let startTime = record.startTime else { return }
            let currentTime = Date()
            
            record.count += Int(round(currentTime.timeIntervalSince(startTime)))
            record.startTime = currentTime
            
            if record.count >= record.goal?.count ?? 0 {
                record.count = record.goal?.count ?? 0
                record.isSuccess = true
                record.startTime = nil
                completeAction()
            }
            
            await self.repository.updateData()
        }
    }
    
    func setNotice(record: DailyRecordModel, notice: Int?) async {
        record.notice = notice
        await repository.updateData()
    }
    
    func deleteRecord(record: DailyRecordModel) async {
        await repository.deleteRecord(record: record)
    }
    
    func deleteGoal(goal: DailyGoalModel) async {
        await repository.deleteGoal(goal: goal)
    }
    
    func getDeleteRecords(goal: DailyGoalModel) async -> [DailyRecordModel] {
        guard let futureRecords = await repository.getFutureRecords() else { return [] }
        return futureRecords.filter { $0.goal?.id == goal.id }
    }
}

// MARK: - records formatting func
extension CalendarUseCase {
    func filterRecords(records: [DailyRecordModel], filter: Symbols) -> [DailyRecordModel] {
        records.filter { filter == .all || $0.goal?.symbol == filter }
    }
    
    func sortRecords(records: [DailyRecordModel]) -> [DailyRecordModel] {
        records.sorted {
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.isSetTime != nextGoal.isSetTime {
                return !prevGoal.isSetTime && nextGoal.isSetTime
            }
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.setTime != nextGoal.setTime {
                return prevGoal.setTime < nextGoal.setTime
            }
            return $0.date < $1.date
        }
    }
    
    private func setFilterData(records: [DailyRecordModel]) -> [Symbols: Int] {
        Symbols.allCases.reduce(into: [:]) { result, symbol in
            result[symbol] = filterRecords(records: records, filter: symbol).count
        }
    }
    
    private func getRecordsByDate(records: [DailyRecordModel]?) -> [Date: [DailyRecordModel]] {
        var recordsByDate: [Date: [DailyRecordModel]] = [:]
        
        records?.forEach { record in
            let components = calendar.dateComponents([.year, .month, .day], from: record.date)
            if let date = calendar.date(from: components) {
                recordsByDate[date, default: []].append(record)
            }
        }
        
        return recordsByDate
    }
    
    func getYearDatas(records: [DailyRecordModel], filter: Symbols) -> YearDataModel {
        let filterData = setFilterData(records: records)
        
        let filteredRecords = filterRecords(records: records, filter: filter)
        let recordsByDate = getRecordsByDate(records: filteredRecords)
        
        var ratings: [[Double?]] = Array(repeating: Array(repeating: nil, count: 31), count: 12)
        for (date, dayRecords) in recordsByDate {
            ratings[date.month - 1][date.day - 1] = CalendarServices.shared.getRating(records: dayRecords)
        }
        
        return YearDataModel(ratings: ratings, filterData: filterData)
    }
    
    func getMonthDatas(records: [DailyRecordModel], filter: Symbols) -> MonthDataModel {
        let filterData = setFilterData(records: records)
        
        let filteredRecords = filterRecords(records: records, filter: filter)
        let sortedRecords = sortRecords(records: filteredRecords)
        let recordsByDate = getRecordsByDate(records: sortedRecords)
        
        var daysOnMonth: [DayOnMonth] = Array(repeating: DayOnMonth(), count: 31)
        for (date, dayRecords) in recordsByDate {
            var dailySymbols: [DailySymbol] = []
            dayRecords.forEach { record in
                guard let goal = record.goal else { return }
                dailySymbols.append(DailySymbol(symbol: goal.symbol, isSuccess: record.isSuccess))
            }
            daysOnMonth[date.day - 1] = DayOnMonth(symbols: dailySymbols, rating: CalendarServices.shared.getRating(records: dayRecords))
        }
        
        return MonthDataModel(daysOnMonth: daysOnMonth, filterData: filterData)
    }
    
    func getWeekDatas(records: [DailyRecordModel], filter: Symbols) -> WeekDataModel {
        let filteredRecords = filterRecords(records: records, filter: filter)
        let recordsByDate = getRecordsByDate(records: filteredRecords)
        
        var ratingsOfWeek: [Double?] = Array(repeating: nil, count: GeneralServices.week)
        for (date, dayRecords) in recordsByDate {
            ratingsOfWeek[date.dailyWeekday(startDay: UserDefaultManager.startDay ?? .zero)] = CalendarServices.shared.getRating(records: dayRecords)
        }
        
        return WeekDataModel(ratingsOfWeek: ratingsOfWeek)
    }
    
    func getDayDatas(records: [DailyRecordModel], filter: Symbols) -> DayDataModel {
        let filterData = setFilterData(records: records)
        
        let filteredRecords = filterRecords(records: records, filter: filter)
        let sortedRecords = sortRecords(records: filteredRecords)
        
        let recordsInList = sortedRecords.reduce(into: [DailyRecordInList]()) { result, record in
            let prevGoal = result.last?.record.goal
            let isShowTimeline = record.goal.map { goal in
                if goal.isSetTime { return prevGoal.map { !$0.isSetTime || $0.setTime != goal.setTime } ?? true }
                return false
            } ?? false
            result.append(DailyRecordInList(record: record, isShowTimeline: isShowTimeline))
        }
        
        return DayDataModel(isEmpty: records.isEmpty, recordsInList: recordsInList, filterData: filterData)
    }
}
