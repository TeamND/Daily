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
            return "weekly".localized
        case .custom:
            return "custom".localized
        }
    }
}
