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
    var isAll: Bool = false
}
