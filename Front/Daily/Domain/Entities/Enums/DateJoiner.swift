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
    
    func joinString(type: CalendarType, hasSpacing: Bool) -> String {
        var joinString: String = ""
        switch self {
        case .none, .dot, .hyphen:
            return self.rawValue
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
