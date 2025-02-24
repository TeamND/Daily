//
//  CalendarInterface.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

protocol CalendarInterface {
    func getYearRecords(date: Date) async -> [DailyRecordModel]?
    func getMonthRecords(date: Date) async -> [DailyRecordModel]?
}
