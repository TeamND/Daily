//
//  YearDataModel.swift
//  Daily
//
//  Created by seungyooooong on 4/16/25.
//

import Foundation

struct YearDataModel: DailyDataModel {
    let ratings: [[Double?]]
    let filterData: [Symbols: Int]
    
    init(ratings: [[Double?]] = Array(repeating: Array(repeating: nil, count: 31), count: 12), filterData: [Symbols: Int] = [:]) {
        self.ratings = ratings
        self.filterData = filterData
    }
}
