//
//  ChartInterface.swift
//  Daily
//
//  Created by seungyooooong on 5/22/25.
//

import Foundation

protocol ChartInterface {
    func getRecords(startDate: Date, endDate: Date) async -> [DailyRecordModel]?
}
