//
//  RepeatTypes.swift
//  Daily
//
//  Created by seungyooooong on 6/17/25.
//

import Foundation

enum RepeatTypes: String, CaseIterable {
    case weekly
    case custom
    
    var text: String {
        switch self {
        case .weekly:
            return "매주"
        case .custom:
            return "사용자화"
        }
    }
}
