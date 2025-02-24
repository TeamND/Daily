//
//  CalendarInterface.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

protocol CalendarInterface {
    func getYearData(date: Date, selection: String) async -> [DailyRecordModel]?
}
