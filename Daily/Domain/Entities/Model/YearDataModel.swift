//
//  YearDataModel.swift
//  Daily
//
//  Created by seungyooooong on 4/16/25.
//

import Foundation

struct YearDataModel {
    let ratings: [[Double]]
    
    init(ratings: [[Double]] = Array(repeating: Array(repeating: 0.0, count: 31), count: 12)) {
        self.ratings = ratings
    }
}
