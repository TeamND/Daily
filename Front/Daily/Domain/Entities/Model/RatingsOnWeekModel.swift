//
//  RatingsOnWeekModel.swift
//  Daily
//
//  Created by seungyooooong on 11/14/24.
//

import Foundation

struct RatingsOnWeekModel: Decodable {
    let rating: [Double]
    let ratingOfWeek: Double
    
    init(rating: [Double] = [], ratingOfWeek: Double = 0.0) {
        self.rating = rating
        self.ratingOfWeek = ratingOfWeek
    }
}
