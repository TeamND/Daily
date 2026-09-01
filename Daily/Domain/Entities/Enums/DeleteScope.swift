//
//  DeleteScope.swift
//  Daily
//
//  Created by seungyooooong on 9/1/26.
//

import Foundation

enum DeleteScope {
    case single
    case future
    case all
    
    var parameterValue: String {
        switch self {
        case .single:
            return "single"
        case .future:
            return "future"
        case .all:
            return "all"
        }
    }
}
