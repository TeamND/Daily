//
//  ResponseModel.swift
//  Daily
//
//  Created by 최승용 on 3/17/24.
//

import Foundation

struct ResponseModel: Codable {
    let code: String
    let message: String
    
    init() {
        self.code = "99"
        self.message = "Network Error"
    }
}
