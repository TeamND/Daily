//
//  Settings.swift
//  Daily
//
//  Created by seungyooooong on 5/3/25.
//

import Foundation

enum Settings {
    case serviceEnvironment
    case appInfo
    
    var label: String {
        switch self {
        case .serviceEnvironment:
            return "app_preferences".localized
        case .appInfo:
            return "app_info".localized
        }
    }
    
    enum ServiceEnvironmentSetting: CaseIterable {
        case language
        case startWeekday
        case filterAlignment
        
        var text: String {
            switch self {
            case .language:
                return "language".localized
            case .startWeekday:
                return "start_of_the_week".localized
            case .filterAlignment:
                return "reorder_filters".localized
            }
        }
    }
    
    enum AppInfo: CaseIterable {
        case targetOS
        case version
        case notion
        case github
        
        var text: String {
            switch self {
            case .targetOS:
                return "compatibility".localized
            case .version:
                return "version".localized
            case .notion:
                return "user_guide".localized
            case .github:
                return "github".localized
            }
        }
        
        var content: String? {
            switch self {
            case .targetOS:
                return "iOS 17.0"
            case .version:
                return System.appVersion
            default:
                return nil
            }
        }
        
        var link: String? {
            switch self {
            case .notion:
                return "seungyooooong.notion.site/Daily-44127143818b4a8f8d9e864d992b549f?pvs=4"
            case .github:
                return "github.com/TeamND/Daily"
            default:
                return nil
            }
        }
    }
}
