//
//  getCalendarMonthModel.swift
//  Daily
//
//  Created by 최승용 on 3/18/24.
//

import Foundation

struct getCalendarMonthModel: Codable {
    let code: String
    let message: String
    let data: [dayOnMonthModel]
    
    init() {
        self.code = "99"
        self.message = "Network Error"
        self.data = []
    }
}

struct dayOnMonthModel: Codable {
    var symbol: [symbolOnMonthModel]
    var rating: Double
    
    init() {
        symbol = [symbolOnMonthModel()]
        rating = 0.0
    }
    init(symbol: symbolOnMonthModel, rating: Double) {
        self.symbol = [symbol]
        self.rating = rating
    }
}

struct symbolOnMonthModel: Codable {
    var imageName: String
    var isSuccess: Bool
    
    init() {
        imageName = ""
        isSuccess = false
    }
    init(imageName: String, isSuccess: Bool) {
        self.imageName = imageName
        self.isSuccess = isSuccess
    }
}
