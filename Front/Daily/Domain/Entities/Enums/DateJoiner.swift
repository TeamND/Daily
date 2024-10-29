//
//  DateJoiner.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

enum DateJoiner {
    case none
    case dot
    case hyphen
    case korean
    
    func joinString(type: CalendarType, hasSpacing: Bool = false) -> String {
        var joinString: String = ""
        switch self {
        case .none:
            break
        case .dot:
            joinString = "."
        case .hyphen:
            switch type {
            case .year, .month:
                joinString = "-"
            case .day:
                joinString = ""
            }
        case .korean:
            switch type {
            case .year:
                joinString = "년"
            case .month:
                joinString = "월"
            case .day:
                joinString = "일"
            }
        }
        return joinString + (hasSpacing ? " " : "")
    }
}
