//
//  ModifyDataModel.swift
//  Daily
//
//  Created by seungyooooong on 12/1/24.
//

import Foundation

struct ModifyDataModel: Hashable {
    var modifyRecord: DailyRecordModel
    var modifyType: ModifyTypes
    var isAll: Bool = false
    var date: Date? = nil
}

enum ModifyTypes {
    case record
    case date
    case goal
}
