//
//  RatingOnWeekModel.swift
//  Daily
//
//  Created by 최승용 on 5/20/24.
//

import Foundation

struct RatingOnWeekModel: Identifiable {
    var id: String = UUID().uuidString
    var day: String
    var rating: Double
}
