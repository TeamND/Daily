//
//  ModifyDataModel.swift
//  Daily
//
//  Created by seungyooooong on 12/1/24.
//

import Foundation

struct ModifyDataModel: Hashable {
    let date: Date
    var modifyRecord: DailyRecordModel
    let modifyType: ModifyTypes
}

enum ModifyTypes {
    case record
    case single
    case all
}
