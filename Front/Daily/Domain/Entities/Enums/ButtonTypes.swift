//
//  ButtonTypes.swift
//  Daily
//
//  Created by seungyooooong on 1/3/25.
//

import Foundation

enum ButtonTypes {
    case add
    case modify
    
    var text: String {
        switch self {
        case .add:
            return "추가"
        case .modify:
            return "수정"
        }
    }
}
