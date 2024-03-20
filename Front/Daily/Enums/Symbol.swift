//
//  Symbol.swift
//  Daily
//
//  Created by 최승용 on 3/20/24.
//

import Foundation

enum Symbol: String, CaseIterable {
    case 빈값 = ""
    case 체크 = "checkmark.circle"
    case 운동 = "dumbbell"
    case 런닝 = "figure.run.circle"
    case 공부 = "book"
    case 키보드 = "keyboard"
    case 하트 = "heart"
    case 별 = "star"
    case 커플 = "person.2.crop.square.stack"
    case 모임 = "person.3"
    
    func toString() -> String {
        switch self {
        case .체크:
            return "체크"
        case .운동:
            return "운동"
        case .런닝:
            return "런닝"
        case .공부:
            return "공부"
        case .키보드:
            return "키보드"
        case .하트:
            return "하트"
        case .별:
            return "별"
        case .커플:
            return "커플"
        case .모임:
            return "모임"
        default:
            return ""
        }
    }
}
