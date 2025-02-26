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
            return textPosition == .title ? String(currentDate.day) + "일" : String(currentDate.month) + "월"
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

// MARK: - get records data func
extension CalendarUseCase {
    func getRatingsOfYear(selection: String) async -> [[Double]] {
        let records = await repository.getYearRecords(selection: selection)
        let recordsByDate = getRecordsByDate(records: records)
        
        var ratingsOfYear = Array(repeating: Array(repeating: 0.0, count: 31), count: 12)
        for (date, dayRecords) in recordsByDate {
            let successCount = dayRecords.filter { $0.isSuccess }.count
            let totalCount = dayRecords.count
            
            if totalCount > 0 {
                ratingsOfYear[date.month - 1][date.day - 1] = Double(successCount) / Double(totalCount)
            }
        }
        
        return ratingsOfYear
    }
    
    func getMonthDatas(selection: String) async -> [MonthDataModel] {
        let records = await repository.getMonthRecords(selection: selection)
        let recordsByDate = getRecordsByDate(records: records)
        
        let selections = CalendarServices.shared.separateSelection(selection)
        let startOfMonth = calendar.date(from: DateComponents(year: selections[0], month: selections[1], day: 1))!
        let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
        
        var monthDatas: [MonthDataModel] = Array(repeating: MonthDataModel(), count: lengthOfMonth)
        for day in 1 ... lengthOfMonth {
            if let dayDate = calendar.date(from: DateComponents(year: selections[0], month: selections[1], day: day)),
               let dayRecords = recordsByDate[dayDate] {
                
                var dailySymbols: [DailySymbol] = []
                dayRecords.forEach { record in
                    if let goal = record.goal {
                        dailySymbols.append(DailySymbol(symbol: goal.symbol, isSuccess: record.isSuccess))
                    }
                }
                
                let rating = dayRecords.isEmpty ? 0.0 : Double(dayRecords.filter { $0.isSuccess }.count) / Double(dayRecords.count)
                monthDatas[day - 1] = MonthDataModel(symbol: dailySymbols, rating: rating)
            }
        }
        
        return monthDatas
    }
    
    func getRatingsOfWeek(selection: String) async -> [Double] {
        let records = await repository.getWeekRecords(selection: selection)
        let recordsByDate = getRecordsByDate(records: records)
        
        var ratingsOfWeek = Array(repeating: 0.0, count: 7)
        for (date, dayRecords) in recordsByDate {
            let successCount = dayRecords.filter { $0.isSuccess }.count
            let totalCount = dayRecords.count
            
            if totalCount > 0 {
                ratingsOfWeek[date.dailyWeekday(startDay: UserDefaultManager.startDay ?? 0)] = Double(successCount) / Double(totalCount)
            }
        }
        
        return ratingsOfWeek
    }
    
    func getRecords(selection: String) async -> [DailyRecordModel] {
        let records = await repository.getDayRecords(selection: selection) ?? []
        // TODO: 추후 수정
        return records.sorted {
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.isSetTime != nextGoal.isSetTime {
                return !prevGoal.isSetTime && nextGoal.isSetTime
            }
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.setTime != nextGoal.setTime {
                return prevGoal.setTime < nextGoal.setTime
            }
            return $0.date < $1.date
        }
    }
    
    func getWeeklyPercentage(selection: String) async -> Int {
        let records = await repository.getWeekRecords(selection: selection)
        
        let validRecords = records?.filter { record in
            record.date <= Date()
        }

        guard let totalRecords = validRecords?.count, totalRecords > 0 else { return 0 }

        guard let successCount = validRecords?.filter({ $0.isSuccess }).count else { return 0 }
        let successRate = Double(successCount) / Double(totalRecords) * 100

        return Int(round(successRate))
    }
}

// MARK: - update or delete records func
extension CalendarUseCase {
    func addCount(goal: DailyGoalModel, record: DailyRecordModel) async {
        record.count += 1
        record.isSuccess = record.count >= goal.count
        await repository.updateData()
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
        return await repository.getDeleteRecords(goal: goal)
    }
}

// MARK: - private func
extension CalendarUseCase {
    private func getRecordsByDate(records: [DailyRecordModel]?) -> [Date: [DailyRecordModel]] {
        var recordsByDate: [Date: [DailyRecordModel]] = [:]
        
        records?.forEach { record in
            let components = calendar.dateComponents([.year, .month, .day], from: record.date)
            if let normalizedDate = calendar.date(from: components) {
                recordsByDate[normalizedDate, default: []].append(record)
            }
        }
        
        return recordsByDate
    }
}
