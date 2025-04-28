//
//  DayDataModel.swift
//  Daily
//
//  Created by seungyooooong on 4/16/25.
//

import Foundation

struct DayDataModel: DailyDataModel {
    let recordsInList: [DailyRecordInList]
    let filterData: [Symbols: Int]
    
    init(recordsInList: [DailyRecordInList] = [], filterData: [Symbols: Int] = [:]) {
        self.recordsInList = recordsInList
        self.filterData = filterData
    }
}

struct DailyRecordInList {
    let record: DailyRecordModel
    let isShowTimeline: Bool
    
    init(record: DailyRecordModel = DailyRecordModel(), isShowTimeline: Bool = false) {
        self.record = record
        self.isShowTimeline = isShowTimeline
    }
}
