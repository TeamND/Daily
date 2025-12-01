//
//  Languages.swift
//  Daily
//
//  Created by seungyooooong on 1/27/25.
//

import Foundation

enum Languages: String, DailyTypes, Codable {
    case korean
    case english
    
    var text: String {
        switch self {
        case .korean:
            return "korean".localized
        case .english:
            return "English"
        }
    }
    
    var languageCode: String {
        switch self {
        case .korean:
            "ko"
        case .english:
            "en"
        }
    }
}

extension Languages {
    static func from(languageCode: String?) -> Languages? {
        return Self.allCases.first { $0.languageCode == languageCode }
    }
}
