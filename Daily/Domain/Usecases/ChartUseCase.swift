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
    func getChartDatas(type: CalendarTypes) async -> [ChartDataModel] {
        var chartDatas: [ChartDataModel] = []
        
        for index in 0 ..< 7 {
            let value = type == .week ? 7 * index : index
            
            guard let startDate = calendar.date(byAdding: type.byAdding, value: -value, to: Date(format: .daily)),
                  let endDate = calendar.date(byAdding: type.byAdding, value: -value + 1, to: Date(format: .daily))?.addingTimeInterval(-1),
                  let records = await repository.getRecords(startDate: startDate, endDate: endDate),
                  let weekday = DayOfWeek.text(for: startDate.weekday - 1)  else { continue }
            
            let chartData = ChartDataModel(isNow: index == 0,
                                           unit: ChartUnit(weekday: weekday, string: endDate.toString(format: type.dateFormat)),
                                           rating: CalendarServices.shared.getRating(records: records).map { $0 * 100 })
            
            chartDatas.insert(chartData, at: 0)
        }
        
        return chartDatas
    }
}
