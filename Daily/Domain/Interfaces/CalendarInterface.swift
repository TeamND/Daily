//
//  CalendarInterface.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

protocol CalendarInterface {
    func getYearRecords(selection: String) async -> [DailyRecordModel]?
    func getMonthRecords(selection: String) async -> [DailyRecordModel]?
    func getWeekRecords(selection: String) async -> [DailyRecordModel]?
    func getDayRecords(selection: String) async -> [DailyRecordModel]?
}
