//
//  getUserInfoModel.swift
//  Daily
//
//  Created by 최승용 on 3/15/24.
//

import Foundation

struct getUserInfoModel: Codable {
    let code: String
    let message: String
    let data: UserInfoModel
    
    init() {
        self.code = "99"
        self.message = "Network Error"
        self.data = UserInfoModel()
    }
}
