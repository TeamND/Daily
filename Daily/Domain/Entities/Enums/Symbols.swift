//
//  Symbols.swift
//  Daily
//
//  Created by seungyooooong on 11/25/24.
//

import Foundation

enum Symbols: String, CaseIterable, Codable {
    case check = "체크"
    case training = "운동"
    case running = "런닝"
    case study = "공부"
    case keyboard = "키보드"
    case heart = "하트"
    case star = "별"
    case couple = "커플"
    case people = "모임"
    
    var imageName: String {
        switch self {
        case .check:
            return "checkmark.circle"
        case .training:
            return "dumbbell"
        case .running:
            return "figure.run.circle"
        case .study:
            return "book"
        case .keyboard:
            return "keyboard"
        case .heart:
            return "heart"
        case .star:
            return "star"
        case .couple:
            return "person.2.crop.square.stack"
        case .people:
            return "person.3"
        }
    }
}
