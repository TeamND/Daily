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
    
    @Published private(set) var yearDictionary: [String: [DailyRecordModel]] = [:]
    @Published private(set) var monthDictionary: [String: [DailyRecordModel]] = [:]
    @Published private(set) var weekDictionary: [String: [DailyRecordModel]] = [:]
    @Published private(set) var dayDictionary: [String: [DailyRecordModel]] = [:]
    
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
    func fetchYearData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getYearRecords(selection: selection)
                await MainActor.run { self.yearDictionary[selection] = records }
            }
        }
    }
    
    func fetchMonthData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getMonthRecords(selection: selection)
                await MainActor.run { self.monthDictionary[selection] = records }
            }
        }
    }
    
    func fetchWeekData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getWeekRecords(selection: selection)
                await MainActor.run { self.weekDictionary[selection] = records }
            }
        }
    }
    
    func fetchDayData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getDayRecords(selection: selection)
                await MainActor.run { self.dayDictionary[selection] = records }
            }
        }
    }
}

// MARK: - button action
extension CalendarViewModel {
    func actionOfRecordButton(record: DailyRecordModel) {
        guard let goal = record.goal else { return }
        
        Task { @MainActor in
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
        
        Task { @MainActor in
            await calendarUseCase.setNotice(record: record, notice: noticeTime.rawValue)
            completeAction()
        }
    }
    
    func removeNotice(record: DailyRecordModel, completeAction: @escaping () -> Void) {
        PushNoticeManager.shared.removeNotice(id: String(describing: record.id))
        
        Task { @MainActor in
            await calendarUseCase.setNotice(record: record, notice: nil)
            completeAction()
        }
    }
    
    func deleteRecord(record: DailyRecordModel, completeAction: @escaping () -> Void) {
        if record.notice != nil { removeNotice(record: record, completeAction: completeAction) }
        
        Task { @MainActor in
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
        
        Task { @MainActor in
            deleteGoalInDictionary(goal: goal)
            await calendarUseCase.deleteGoal(goal: goal)
            fetchDayData(selection: currentDate.getSelection(type: .day))
            fetchWeekData(selection: currentDate.getSelection(type: .week))
        }
    }
    
    func deleteRecords(goal: DailyGoalModel, completeAction: @escaping () -> Void) {
        Task { @MainActor in
            let deleteRecords = await calendarUseCase.getDeleteRecords(goal: goal)
            deleteRecords.forEach {
                deleteRecord(record: $0, completeAction: completeAction)
            }
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
    func filterRecords(records: [DailyRecordModel]) -> [DailyRecordModel] {
        calendarUseCase.filterRecords(records: records, filter: filter)
    }
    
    func sortRecords(records: [DailyRecordModel]) -> [DailyRecordModel] {
        calendarUseCase.sortRecordsBySetTime(records: records)
    }
    
    func getRatingsOfYear(records: [DailyRecordModel]) -> [[Double]] {
        calendarUseCase.getRatingsOfYear(records: records)
    }
    
    func getMonthDatas(records: [DailyRecordModel]) -> [MonthDataModel] {
        calendarUseCase.getMonthDatas(records: records)
    }
    
    func getRatingsOfWeek(records: [DailyRecordModel]) -> [Double] {
        calendarUseCase.getRatingsOfWeek(records: records)
    }
    
    func getRatingOfWeek(records: [DailyRecordModel]) -> Int {
        calendarUseCase.getRatingOfWeek(records: records)
    }
}
