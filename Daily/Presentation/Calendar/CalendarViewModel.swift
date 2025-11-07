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
    
    @Published private(set) var yearData: [String: YearDataModel] = [:]
    @Published private(set) var monthData: [String: MonthDataModel] = [:]
    @Published private(set) var weekData: [String: WeekDataModel] = [:]
    @Published private(set) var dayData: [String: DayDataModel] = [:]
    
    private(set) var yearDictionary: [String: [DailyRecordModel]] = [:]
    private(set) var monthDictionary: [String: [DailyRecordModel]] = [:]
    private(set) var weekDictionary: [String: [DailyRecordModel]] = [:]
    private(set) var dayDictionary: [String: [DailyRecordModel]] = [:]
    
    private(set) var timer: Timer?
    
    func bindSelection(type: CalendarTypes) -> Binding<String> {
        Binding(
            get: { self.currentDate.getSelection(type: type) },
            set: { self.setDate(selection: $0) }
        )
    }
    
    init() {
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
        
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

extension CalendarViewModel {
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }

            for records in self.dayDictionary.values {
                for record in records {
                    self.calendarUseCase.updateTimer(record: record) { [weak self] in
                        guard let self else { return }
                        self.fetchWeekData(selection: self.currentDate.getSelection(type: .week))
                    }
                }
            }
        }
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
        if self.filter == filter {
            self.filter = .all
        } else {
            self.filter = filter
        }
        
        yearData.forEach {
            let records = yearDictionary[$0.key] ?? []
            let yearDatas = getYearDatas(records: records)
            yearData[$0.key] = yearDatas
        }
        
        monthData.forEach {
            let records = monthDictionary[$0.key] ?? []
            let monthDatas = getMonthDatas(records: records)
            monthData[$0.key] = monthDatas
        }
        
        weekData.forEach {
            let records = weekDictionary[$0.key] ?? []
            let weekDatas = getWeekDatas(records: records)
            weekData[$0.key] = weekDatas
        }
        
        dayData.forEach {
            let records = dayDictionary[$0.key] ?? []
            let dayDatas = getDayDatas(records: records)
            dayData[$0.key] = dayDatas
        }
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

                let yearDatas = getYearDatas(records: records)
                await MainActor.run { self.yearData[selection] = yearDatas }
            }
        }
    }
    
    func fetchMonthData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getMonthRecords(selection: selection)
                self.monthDictionary[selection] = records
                
                let monthDatas = getMonthDatas(records: records)
                await MainActor.run { self.monthData[selection] = monthDatas }
            }
        }
    }
    
    func fetchWeekData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getWeekRecords(selection: selection)
                self.weekDictionary[selection] = records
                
                let weekDatas = getWeekDatas(records: records)
                await MainActor.run { self.weekData[selection] = weekDatas }
            }
        }
    }
    
    func fetchDayData(selection: String) {
        Task {
            await TaskQueueManager.shared.add { [weak self] in
                guard let self else { return }
                let records = await self.calendarUseCase.getDayRecords(selection: selection)
                self.dayDictionary[selection] = records
                
                let dayDatas = getDayDatas(records: records)
                await MainActor.run { self.dayData[selection] = dayDatas }
            }
        }
    }
}

// MARK: - button action
extension CalendarViewModel {
    func actionOfRecordButton(record: DailyRecordModel) {
        guard let goal = record.goal, let type = goal.type else { return }
        
        Task {
            switch type {
            case .check, .count:
                await calendarUseCase.addCount(goal: goal, record: record)
                fetchDayData(selection: currentDate.getSelection(type: .day))
                fetchWeekData(selection: currentDate.getSelection(type: .week))
            case .timer:
                await calendarUseCase.toggleStartTime(record: record)
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
        Task {
            await resetData()
            await deleteRecordContainNotice(record: record, completeAction: completeAction)
            
            fetchDayData(selection: currentDate.getSelection(type: .day))
            fetchWeekData(selection: currentDate.getSelection(type: .week))
        }
    }
    
    // TODO: 추후 최적화 필요
    func deleteGoal(goal: DailyGoalModel, completeAction: @escaping () -> Void) {
        guard let records = goal.records else { return }
        Task {
            await resetData()
            await calendarUseCase.deleteGoal(goal: goal)
            for record in records { await deleteRecordContainNotice(record: record, completeAction: completeAction) }
            
            fetchDayData(selection: currentDate.getSelection(type: .day))
            fetchWeekData(selection: currentDate.getSelection(type: .week))
        }
    }
    
    func deleteRecords(goal: DailyGoalModel, completeAction: @escaping () -> Void) {
        Task {
            let deleteRecords = await calendarUseCase.getDeleteRecords(goal: goal)
            
            await resetData()
            for record in deleteRecords { await deleteRecordContainNotice(record: record, completeAction: completeAction) }
            
            fetchDayData(selection: currentDate.getSelection(type: .day))
            fetchWeekData(selection: currentDate.getSelection(type: .week))
        }
    }
}

// MARK: - getDatas
extension CalendarViewModel {
    private func getYearDatas(records: [DailyRecordModel]) -> YearDataModel {
        calendarUseCase.getYearDatas(records: records, filter: filter)
    }
    
    private func getMonthDatas(records: [DailyRecordModel]) -> MonthDataModel {
        calendarUseCase.getMonthDatas(records: records, filter: filter)
    }
    
    private func getWeekDatas(records: [DailyRecordModel]) -> WeekDataModel {
        calendarUseCase.getWeekDatas(records: records, filter: filter)
    }
    
    private func getDayDatas(records: [DailyRecordModel]) -> DayDataModel {
        calendarUseCase.getDayDatas(records: records, filter: filter)
    }
    
    func getData(type: CalendarTypes) -> DailyDataModel? {
        switch type {
        case .year:
            return yearData[currentDate.getSelection(type: type)]
        case .month:
            return monthData[currentDate.getSelection(type: type)]
        case .week:
            return nil
        case .day:
            return dayData[currentDate.getSelection(type: type)]
        }
    }
    
    @MainActor
    func resetData() {
        weekData = [:]
        dayData = [:]
    }
    
    private func deleteRecordContainNotice(record: DailyRecordModel, completeAction: @escaping () -> Void) async {
        if record.notice != nil { removeNotice(record: record, completeAction: completeAction) }
        await calendarUseCase.deleteRecord(record: record)
    }
}
