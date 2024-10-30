//
//  SymbolsOnMonthModel.swift
//  Daily
//
//  Created by seungyooooong on 10/30/24.
//

import Foundation

struct SymbolsOnMonthModel: Decodable {
    var symbol: [SymbolOnMonthModel]
}

struct SymbolOnMonthModel: Decodable {
    var imageName: String
    var isSuccess: Bool
}
