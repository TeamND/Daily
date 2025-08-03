//
//  GoalDataEntity.swift
//  Daily
//
//  Created by seungyooooong on 8/3/25.
//

import Foundation

struct GoalDataEntity: Hashable {
    let record: DailyRecordModel
    let modifyType: ModifyTypes?
    
    init(date: Date? = nil, record: DailyRecordModel = DailyRecordModel(), modifyType: ModifyTypes? = nil) {
        if let date { record.date = date }
        self.record = record
        self.modifyType = modifyType
    }
}
