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
    
    // MARK: holiday [year: [yyyy-MM-dd: HolidayEntity]]
    @UserDefault(key: .holidays, defaultValue: nil) static var holidays: [Int: [String: HolidayEntity]]?
}

enum UserDefaultKey: String {
    case startDay
    case language
    case calendarType
    case ignoreNoticeDate
    case beforeVersion
    case holidays
}

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: UserDefaultKey
    let defaultValue: T?
    let storage: UserDefaults = UserDefaults.standard
    
    init(key: UserDefaultKey, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            // MARK: 원시 타입
            if let value = storage.object(forKey: key.rawValue) as? T { return value }

            // MARK: 커스텀 타입 디코딩
            if let data = storage.data(forKey: key.rawValue) { return try? JSONDecoder().decode(T.self, from: data) }

            // MARK: 기본값
            return defaultValue
        }
        set {
            // FIXME: nil 예외 처리 필요한지 확인 후 수정
//            guard let newValue else {
//                storage.removeObject(forKey: key.rawValue)
//                return
//            }

            // MARK: 커스텀 타입 인코딩
            if let encoded = try? JSONEncoder().encode(newValue) {
                storage.set(encoded, forKey: key.rawValue)
            } else {    // MARK: 원시 타입
                storage.set(newValue, forKey: key.rawValue)
            }
        }
    }
}
