//
//  Languages.swift
//  Daily
//
//  Created by seungyooooong on 1/27/25.
//

import Foundation

enum Languages: String, DailyTypes {
    case korean
    case english
    
    var text: String {
        switch self {
        case .korean:
            return "한국어"
        case .english:
            return "English"
        }
    }
}
