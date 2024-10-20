//
//  getCalendarYearModel.swift
//  Daily
//
//  Created by 최승용 on 3/24/24.
//

import Foundation

struct getCalendarYearModel: Codable {
    let code: String
    let message: String
    let data: [[Double]]
    
    init() {
        self.code = "99"
        self.message = "Network Error"
        self.data = [[]]
    }
}
