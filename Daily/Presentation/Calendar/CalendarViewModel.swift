//
//  CalendarViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import SwiftUI

final class CalendarViewModel: ObservableObject {
    private let calendarUseCase: CalendarUseCase
    
    @Published private(set) var filter: Symbols = .all
    @Published private(set) var currentDate: Date = Date(format: .daily)
    
    @Published private(set) var filterData: [Symbols: Int] = [:]
    @Published private(set) var yearData: [String: YearDataModel] = [:]
    @Published private(set) var monthData: [String: [MonthDataModel]] = [:]
    @Published private(set) var weekData: [String: WeekDataModel] = [:]
    @Published private(set) var dayData: [String: DayDataModel] = [:]
    
    private(set) var yearDictionary: [String: [DailyRecordModel]] = [:]
    private(set) var monthDictionary: [String: [DailyRecordModel]] = [:]
    private(set) var weekDictionary: [String: [DailyRecordModel]] = [:]
    private(set) var dayDictionary: [String: [DailyRecordModel]] = [:]
    
    @Published var isShowWeeklySummary: Bool = false    // TODO: 추후 수정
    
    func bindSelection(type: CalendarTypes) -> Binding<String> {
        Binding(
            get: { self.currentDate.getSelection(type: type) },
            set: { self.setDate(selection: $0) }
        )
    }
    
    init() {
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }
}

// MARK: - setDate
extension CalendarViewModel {
    func setDate(selection: String) {
        let selections = CalendarServices.shared.separateSelection(selection)
        self.setDate(year: selections[0], month: selections[safe: 1], day: selections[safe: 2])
    }
    func setDate(year: Int, month: Int? = nil, day: Int? = nil) {
        let month = month ?? 1
        let day = day ?? (year == Date().year && month == Date().month ? Date().day : 1)
        currentDate = CalendarServices.shared.getDate(year: year, month: month, day: day) ?? Date(format: .daily)
    }
    func setDate(byAdding: Calendar.Component, value: Int) {
        var calendar = Calendar.current
        calendar.timeZone = .current
        currentDate = calendar.date(byAdding: byAdding, value: value, to: currentDate) ?? Date(format: .daily)
    }
    func setDate(date: Date) {
        currentDate = date
    }
    
    func setFilter(filter: Symbols) {
        self.filter = filter
        
        yearData.forEach {
            let records = yearDictionary[$0.key] ?? []
            let filteredRecords = filterRecords(records: records)
            let yearDatas = getYearDatas(records: filteredRecords)
            yearData[$0.key] = yearDatas
        }
        
        monthData.forEach {
            let records = monthDictionary[$0.key] ?? []
            let filteredRecords = filterRecords(records: records)
            let sortedRecords = sortRecords(records: filteredRecords)
            let monthDatas = getMonthDatas(records: sortedRecords)
            monthData[$0.key] = monthDatas
        }
        
        weekData.forEach {
            let records = weekDictionary[$0.key] ?? []
            let filteredRecords = filterRecords(records: records)
            let weekDatas = getWeekDatas(records: filteredRecords)
            weekData[$0.key] = weekDatas
        }
        
        dayData.forEach {
            let records = dayDictionary[$0.key] ?? []
            let filteredRecords = filterRecords(records: records)
            let sortedRecords = sortRecords(records: filteredRecords)
            let dayDatas = getDayDatas(records: sortedRecords)
            dayData[$0.key] = dayDatas
        }
    }
    private func setFilterData(records: [DailyRecordModel]) {
        Symbols.allCases.forEach { filterData[$0] = filterRecords(records: records, filter: $0).count }
    }
}

// MARK: - info
extension CalendarViewModel {
    func loadText(type: CalendarTypes, direction: Direction) -> String {
        calendarUseCase.getLoadText(currentDate: currentDate, type: type, direction: direction)
    }
    
    func headerText(type: CalendarTypes, textPosition: TextPositionInHeader = .title) -> String {
        calendarUseCase.getHeaderText(currentDate: currentDate, type: type, textPosition: textPosition)
    }
    
    func calendarInfo(type: CalendarTypes, index: Int) -> (date: Date, direction: Direction, selection: String) {
        calendarUseCase.getCalendarInfo(currentDate: currentDate, type: type, index: index)
    }
    
    func monthInfo(date: Date) -> (startOfMonthWeekday: Int, lengthOfMonth: Int, dividerCount: Int) {
        calendarUseCase.getMonthInfo(date: date)
    }
}

// MARK: - fetch func
extension CalendarViewModel {
    // TODO: self.dictionary[selection] == reocrds 로 record 내부 데이터 변경을 감지하지 못하는 경우가 있음, 추후 캐싱 및 최적화 로직을 개선
    
    func fetchYearData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getYearRecords(selection: selection)
                self.yearDictionary[selection] = records
                
                let filteredRecords = filterRecords(records: records)
                let yearDatas = getYearDatas(records: filteredRecords)
                await MainActor.run {
                    self.setFilterData(records: records)
                    self.yearData[selection] = yearDatas
                }
            }
        }
    }
    
    func fetchMonthData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getMonthRecords(selection: selection)
                self.monthDictionary[selection] = records
                
                let filteredRecords = filterRecords(records: records)
                let sortedRecords = sortRecords(records: filteredRecords)
                let monthDatas = getMonthDatas(records: sortedRecords)
                await MainActor.run {
                    self.setFilterData(records: records)
                    self.monthData[selection] = monthDatas
                }
            }
        }
    }
    
    func fetchWeekData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getWeekRecords(selection: selection)
                self.weekDictionary[selection] = records
                
                let filteredRecords = filterRecords(records: records)
                let weekDatas = getWeekDatas(records: filteredRecords)
                await MainActor.run {
                    self.setFilterData(records: records)
                    self.weekData[selection] = weekDatas
                }
            }
        }
    }
    
    func fetchDayData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getDayRecords(selection: selection)
                self.dayDictionary[selection] = records
                
                let filteredRecords = filterRecords(records: records)
                let sortedRecords = sortRecords(records: filteredRecords)
                let dayDatas = getDayDatas(records: sortedRecords)
                await MainActor.run { self.dayData[selection] = dayDatas }
            }
        }
    }
}

// MARK: - button action
extension CalendarViewModel {
    func actionOfRecordButton(record: DailyRecordModel) {
        guard let goal = record.goal else { return }
        
        Task {
            switch goal.type {
            case .check, .count:
                await calendarUseCase.addCount(goal: goal, record: record)
                fetchDayData(selection: currentDate.getSelection(type: .day))
                fetchWeekData(selection: currentDate.getSelection(type: .week))
            case .timer: // TODO: 추후 구현
                return
            }
        }
    }
    
    func addNotice(goal: DailyGoalModel, record: DailyRecordModel, noticeTime: NoticeTimes, completeAction: @escaping () -> Void) {
        PushNoticeManager.shared.addNotice(
            id: String(describing: record.id),
            content: goal.content,
            date: record.date,
            setTime: goal.setTime,
            noticeTime: noticeTime
        )
        
        Task {
            await calendarUseCase.setNotice(record: record, notice: noticeTime.rawValue)
            completeAction()
        }
    }
    
    func removeNotice(record: DailyRecordModel, completeAction: @escaping () -> Void) {
        PushNoticeManager.shared.removeNotice(id: String(describing: record.id))
        
        Task {
            await calendarUseCase.setNotice(record: record, notice: nil)
            completeAction()
        }
    }
    
    func deleteRecord(record: DailyRecordModel, completeAction: @escaping () -> Void) {
        if record.notice != nil { removeNotice(record: record, completeAction: completeAction) }
        
        Task {
            deleteRecordInDictionary(record: record)
            await calendarUseCase.deleteRecord(record: record)
            fetchDayData(selection: currentDate.getSelection(type: .day))
            fetchWeekData(selection: currentDate.getSelection(type: .week))
        }
    }
    
    func deleteGoal(goal: DailyGoalModel, completeAction: @escaping () -> Void) {
        goal.records.forEach { record in
            if record.notice != nil { removeNotice(record: record, completeAction: completeAction) }
        }
        
        Task {
            deleteGoalInDictionary(goal: goal)
            await calendarUseCase.deleteGoal(goal: goal)
            fetchDayData(selection: currentDate.getSelection(type: .day))
            fetchWeekData(selection: currentDate.getSelection(type: .week))
        }
    }
    
    func deleteRecords(goal: DailyGoalModel, completeAction: @escaping () -> Void) {
        Task {
            let deleteRecords = await calendarUseCase.getDeleteRecords(goal: goal)
            
            for record in deleteRecords {
                if record.notice != nil { removeNotice(record: record, completeAction: completeAction) }
                
                deleteRecordInDictionary(record: record)
                await calendarUseCase.deleteRecord(record: record)
            }
            
            fetchDayData(selection: currentDate.getSelection(type: .day))
            fetchWeekData(selection: currentDate.getSelection(type: .week))
        }
    }
}

// MARK: - in dictionary
extension CalendarViewModel {
    private func deleteRecordInDictionary(record: DailyRecordModel) {
        for key in dayDictionary.keys {
            dayDictionary[key]?.removeAll { $0.id == record.id }
            if dayDictionary[key]?.isEmpty ?? false { dayDictionary.removeValue(forKey: key) }
        }
    }
    
    private func deleteGoalInDictionary(goal: DailyGoalModel) {
        for key in dayDictionary.keys {
            dayDictionary[key]?.removeAll { recordInDictionary in
                goal.records.contains { record in
                    recordInDictionary.id == record.id
                }
            }
            if dayDictionary[key]?.isEmpty ?? false { dayDictionary.removeValue(forKey: key) }
        }
    }
}

// MARK: - records formatting func
extension CalendarViewModel {
    func filterRecords(records: [DailyRecordModel], filter: Symbols? = nil) -> [DailyRecordModel] {
        calendarUseCase.filterRecords(records: records, filter: filter ?? self.filter)
    }
    
    func sortRecords(records: [DailyRecordModel]) -> [DailyRecordModel] {
        calendarUseCase.sortRecords(records: records)
    }
    
    func getYearDatas(records: [DailyRecordModel]) -> YearDataModel {
        calendarUseCase.getYearDatas(records: records)
    }
    
    func getMonthDatas(records: [DailyRecordModel]) -> [MonthDataModel] {
        calendarUseCase.getMonthDatas(records: records)
    }
    
    func getWeekDatas(records: [DailyRecordModel]) -> WeekDataModel {
        calendarUseCase.getWeekDatas(records: records)
    }
    
    func getDayDatas(records: [DailyRecordModel]) -> DayDataModel {
        calendarUseCase.getDayDatas(records: records)
    }
}
