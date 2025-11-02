//
//  UserDefaultManager.swift
//  Daily
//
//  Created by seungyooooong on 11/15/24.
//

import Foundation

class UserDefaultManager {
    // MARK: setting
    @UserDefault(key: .startDay, defaultValue: nil) static var startDay: Int?
    @UserDefault(key: .language, defaultValue: nil) static var language: String?
    @UserDefault(key: .calendarType, defaultValue: nil) static var calendarType: String?
    
    // MARK: notice
    @UserDefault(key: .ignoreNoticeDate, defaultValue: nil) static var ignoreNoticeDate: Date?
    
    // MARK: migration
    @UserDefault(key: .beforeVersion, defaultValue: nil) static var beforeVersion: String?
}

enum UserDefaultKey: String {
    case startDay
    case language
    case calendarType
    case ignoreNoticeDate
    case beforeVersion
}

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: UserDefaultKey
    let defaultValue: T?
    let storage: UserDefaults = UserDefaults.standard
    
    init(key: UserDefaultKey,
         defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            return self.storage.object(forKey: self.key.rawValue) as? T ?? self.defaultValue
        }
        set {
            self.storage.set(newValue, forKey: self.key.rawValue)
        }
    }
}
