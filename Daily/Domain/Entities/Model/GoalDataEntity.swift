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
    
    init(record: DailyRecordModel = DailyRecordModel(), modifyType: ModifyTypes? = nil) {
        self.record = record
        self.modifyType = modifyType
    }
}
