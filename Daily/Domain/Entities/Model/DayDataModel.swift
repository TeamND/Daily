//
//  DayDataModel.swift
//  Daily
//
//  Created by seungyooooong on 4/16/25.
//

import Foundation

struct DayDataModel: DailyDataModel {
    let isEmpty: Bool
    var recordsInList: [DailyRecordInList]  // MARK: 디비에서 데이터를 삭제하기 전에 리스트에서 먼저 지워줘야 함
    let filterData: [Symbols: Int]
    
    init(isEmpty: Bool = true, recordsInList: [DailyRecordInList] = [], filterData: [Symbols: Int] = [:]) {
        self.isEmpty = isEmpty
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
