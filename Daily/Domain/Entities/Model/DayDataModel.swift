//
//  DayDataModel.swift
//  Daily
//
//  Created by seungyooooong on 4/16/25.
//

import Foundation

struct DayDataModel {
    let recordsInList: [DailyRecordInList]
    
    init(recordsInList: [DailyRecordInList] = []) {
        self.recordsInList = recordsInList
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
