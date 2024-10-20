//
//  getCalendarDayModel.swift
//  Daily
//
//  Created by 최승용 on 3/13/24.
//

import Foundation

struct getCalendarDayModel: Codable {
    let code: String
    let message: String
    let data: getCalendarDayData
    
    init() {
        self.code = "99"
        self.message = "Network Error"
        self.data = getCalendarDayData()
    }
}

struct getCalendarDayData: Codable {
    let goalList: [RecordModel]
    
    init() {
        self.goalList = []
    }
}
