//
//  HolidayImages.swift
//  Daily
//
//  Created by seungyooooong on 11/14/25.
//

import Foundation

enum HolidayImages: String {
    case newYearsDay = "New Year's Day"
    case childrensDay = "Children's Day"
    case christmasDay = "Christmas Day"
    
    var imageName: String {
        switch self {
        case .newYearsDay:
            return "NewYearsDay"
        case .childrensDay:
            return "ChildrensDay"
        case .christmasDay:
            return "ChristmasDay"
        }
    }
}
