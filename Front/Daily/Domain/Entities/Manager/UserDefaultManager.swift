//
//  UserDefaultManager.swift
//  Daily
//
//  Created by seungyooooong on 11/15/24.
//

import Foundation

class UserDefaultManager {
    @UserDefault(key: .userID, defaultValue: nil) static var userID: String?
    @UserDefault(key: .startDay, defaultValue: nil) static var startDay: Int?
    @UserDefault(key: .language, defaultValue: nil) static var language: String?
    @UserDefault(key: .dateType, defaultValue: nil) static var dateType: String?
    @UserDefault(key: .calendarState, defaultValue: nil) static var calendarState: String?
    @UserDefault(key: .lastTime, defaultValue: nil) static var lastTime: String?
    
    static func setUserInfo(userInfo: UserInfoModel) {
        userID = String(userInfo.uid)
        startDay = userInfo.set_startday
        language = userInfo.set_language
        dateType = userInfo.set_dateorrepeat
        calendarState = userInfo.set_calendarstate
        lastTime = userInfo.last_time
    }
}

enum UserDefaultKey: String {
    case userID
    case startDay
    case language
    case dateType
    case calendarState
    case lastTime
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
