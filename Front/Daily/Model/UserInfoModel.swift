//
//  UserInfoModel.swift
//  Daily
//
//  Created by 최승용 on 3/15/24.
//

import Foundation

struct UserInfoModel: Codable {
    let uid: Int
    let set_startday: Int
    let set_language: String
    let set_dateorrepeat: String
    let set_calendarstate: String
}
