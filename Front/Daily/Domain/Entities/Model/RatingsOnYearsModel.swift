//
//  RatingsOnYearsModel.swift
//  Daily
//
//  Created by seungyooooong on 10/31/24.
//

import Foundation

struct RatingsOnYearsModel {
    var yearSelection: String
    var ratingsOnYear: [[Double]]
    
    init(
        yearSelection: String = CalendarServices.shared.formatDateString(year: Date().year),
        ratingsOnYear: [[Double]] = Array(repeating: Array(repeating: 0, count: 31), count: 12)
    ) {
        self.yearSelection = yearSelection
        self.ratingsOnYear = ratingsOnYear
    }
}
