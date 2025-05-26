//
//  WeekDataModel.swift
//  Daily
//
//  Created by seungyooooong on 4/16/25.
//

import Foundation

struct WeekDataModel {
    let ratingsOfWeek: [Double?]
    
    init(ratingsOfWeek: [Double?] = Array(repeating: nil, count: GeneralServices.week)) {
        self.ratingsOfWeek = ratingsOfWeek
    }
}
