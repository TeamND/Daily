//
//  ChartRepository.swift
//  Daily
//
//  Created by seungyooooong on 5/22/25.
//

import Foundation

final class ChartRepository: ChartInterface {
    func getRecords(startDate: Date, endDate: Date) async -> [DailyRecordModel]? {
        return await DailyDataSource.shared.fetchRecords(startDate: startDate, endDate: endDate)
    }
}
