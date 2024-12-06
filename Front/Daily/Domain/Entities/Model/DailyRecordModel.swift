//
//  DailyRecordModel.swift
//  Daily
//
//  Created by seungyooooong on 12/6/24.
//

import Foundation
import SwiftData

@Model
class DailyRecordModel {
    var date: Date
    var isSuccess: Bool
    var count: Int
    
    init(date: Date, isSuccess: Bool, count: Int) {
        self.date = date
        self.isSuccess = isSuccess
        self.count = count
    }
}
