//
//  DateJoiner.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

enum DateJoiner: String {
    case none = ""
    case dot = "."
    case hyphen = "-"
    case korean = "k"
    
    func joinString(type: CalendarTypes, hasSpacing: Bool) -> String {
        var joinString: String = ""
        switch self {
        case .none, .dot, .hyphen:
            joinString = self.rawValue
        case .korean:
            switch type {
            case .year:
                joinString = "년"
            case .month:
                joinString = "월"
            case .day:
                joinString = "일"
            default:
                return ""
            }
        }
        if hasSpacing { joinString += " " }
        return joinString
    }
}
