//
//  DateFormats.swift
//  Daily
//
//  Created by seungyooooong on 1/11/25.
//

import Foundation

enum DateFormats: String {
    case daily = "yyyy-MM-dd"
    case setTime = "HH:mm"
    
    case year = "yyyy"
    case month = "M월"
    case week = "~M.d"
    case day = "M.d"
    
    case singleDate = "yyyy. MM. dd. E"
    case multiDate = "yy. MM. dd. E"
    case AMPMTime = "a h:mm"
}
