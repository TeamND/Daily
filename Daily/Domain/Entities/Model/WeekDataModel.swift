//
//  WeekDataModel.swift
//  Daily
//
//  Created by seungyooooong on 4/16/25.
//

import Foundation

struct WeekDataModel {
    let ratingOfWeek: Int
    let ratingsOfWeek: [Double]
    let ratingsForChart: [RatingOnWeekModel]
    
    init(
        ratingOfWeek: Int = 0,
        ratingsOfWeek: [Double] = Array(repeating: 0.0, count: GeneralServices.week),
        ratingsForChart: [RatingOnWeekModel] = []
    ) {
        self.ratingOfWeek = ratingOfWeek
        self.ratingsOfWeek = ratingsOfWeek
        self.ratingsForChart = ratingsForChart
    }
}
