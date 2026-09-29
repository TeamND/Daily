//
//  GATypes.swift
//  Daily
//
//  Created by seungyooooong on 9/29/26.
//

import Foundation

enum GATypes {
    case view
    case event
    case result
    
    var parameterValue: String {
        switch self {
        case .view:
            return "view"
        case .event:
            return "event"
        case .result:
            return "result"
        }
    }
}
