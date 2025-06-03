//
//  Symbols.swift
//  Daily
//
//  Created by seungyooooong on 11/25/24.
//

import SwiftUI

enum Symbols: String, CaseIterable, Codable {
    case all = "전체"
    case check = "체크"
    case training = "운동"
    case running = "런닝"
    case study = "공부"
    case keyboard = "키보드"
    case money = "돈"
    case heart = "하트"
    case star = "별"
    case couple = "커플"
    case people = "모임"
    
    var imageName: String {
        switch self {
        case .all:
            return ""
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
        case .money:
            return "dollarsign.circle"
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
    
    func icon(isSuccess: Bool) -> ImageResource {
        switch self {
        case .check:
            return isSuccess ? .check : .checkYet
        case .training:
            return isSuccess ? .training : .trainingYet
        case .running:
            return isSuccess ? .running : .runningYet
        case .study:
            return isSuccess ? .study : .studyYet
        case .keyboard:
            return isSuccess ? .keyboard : .keyboardYet
        case .money:
            return isSuccess ? .money : .moneyYet
        case .heart:
            return isSuccess ? .heart : .heartYet
        case .star:
            return isSuccess ? .star : .starYet
        case .couple:
            return isSuccess ? .couple : .coupleYet
        case .people:
            return isSuccess ? .group : .groupYet
        default:
            return isSuccess ? .check : .checkYet
        }
    }
}
