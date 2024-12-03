//
//  SymbolsOnMonthModel.swift
//  Daily
//
//  Created by seungyooooong on 10/30/24.
//

import Foundation

struct SymbolsOnMonthModel: Decodable {
    var symbol: [SymbolOnMonthModel]
    var rating: Double
    
    init(symbol: [SymbolOnMonthModel] = [], rating: Double = 0.0) {
        self.symbol = symbol
        self.rating = rating
    }
}

struct SymbolOnMonthModel: Decodable {
    var imageName: String
    var isSuccess: Bool
    
    init() {
        self.imageName = ""
        self.isSuccess = false
    }
}
