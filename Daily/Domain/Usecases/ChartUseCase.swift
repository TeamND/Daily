//
//  ChartUseCase.swift
//  Daily
//
//  Created by seungyooooong on 5/12/25.
//

import Foundation

final class ChartUseCase {
    private let repository: ChartInterface
    private let calendar: Calendar = CalendarManager.shared.getDailyCalendar()
    
    init(repository: ChartInterface) {
        self.repository = repository
    }
}

extension ChartUseCase {
    func getChartDatas(type: CalendarTypes) async -> (chartDatas: [ChartDataModel], totalCount: Int, successCount: Int) {
        var chartDatas: [ChartDataModel] = []
        var originDate = calendar.date(byAdding: .day, value: 1, to: Date(format: .daily)) ?? Date(format: .daily)
        var totalCount = 0
        var successCount = 0
        
        for index in 0 ..< 7 {
            let endDate = originDate.addingTimeInterval(-1)
            
            guard let startDate = calculateStartDate(type: type, endDate: endDate),
                  let records = await repository.getRecords(startDate: startDate, endDate: endDate),
                  let weekday = DayOfWeek.text(for: startDate.weekday - 1) else { continue }
            
            originDate = startDate
            totalCount += records.count
            successCount += records.filter{ $0.isSuccess }.count
            
            let chartData = ChartDataModel(isNow: index == 0,
                                           unit: ChartUnit(weekday: weekday, string: endDate.toString(format: type.dateFormat)),
                                           rating: CalendarServices.shared.getRating(records: records).map { $0 * 100 })
            
            chartDatas.insert(chartData, at: 0)
        }
        
        return (chartDatas, totalCount, successCount)
    }
    
    private func calculateStartDate(type: CalendarTypes, endDate: Date) -> Date? {
        switch type {
        case .year:
            return "\(endDate.year)-01-01".toDate()
        case .month:
            return "\(endDate.year)-\(endDate.month)-01".toDate()
        case .week:
            return calendar.date(byAdding: type.byAdding, value: -endDate.weekday, to: endDate)?.addingTimeInterval(1)
        case .day:
            return calendar.date(byAdding: type.byAdding, value: -1, to: endDate)?.addingTimeInterval(1)
        }
    }
}
