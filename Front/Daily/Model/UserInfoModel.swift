//
//  UserInfoModel.swift
//  Daily
//
//  Created by 최승용 on 3/15/24.
//

import Foundation

struct UserInfoModel: Codable {
    var uid: Int
    var set_startday: Int
    var set_language: String
    var set_dateorrepeat: String
    var set_calendarstate: String
    
    init() {
        self.uid = 0
        self.set_startday = 0
        self.set_language = "korea"
        self.set_dateorrepeat = "date"
        self.set_calendarstate = "month"
    }
}
