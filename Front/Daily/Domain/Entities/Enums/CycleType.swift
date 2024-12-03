//
//  CycleType.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

enum CycleType: String, CaseIterable {
    case date = "date"
    case rept = "repeat"
    
    var text: String {
        switch self {
        case .date:
            return "날짜 선택"
        case .rept:
            return "요일 반복"
        }
    }
}
