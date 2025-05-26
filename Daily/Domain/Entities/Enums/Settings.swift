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
            return "서비스 환경"
        case .appInfo:
            return "앱 정보"
        }
    }
    
    enum ServiceEnvironmentSetting: CaseIterable {
        case language
        case startWeekday
        case filterAlignment
        
        var text: String {
            switch self {
            case .language:
                return "언어"
            case .startWeekday:
                return "시작 요일"
            case .filterAlignment:
                return "필터 순서"
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
                return "호환성"
            case .version:
                return "버전"
            case .notion:
                return "사용설명서"
            case .github:
                return "Github"
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
