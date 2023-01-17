//
//  ServiceController.swift
//  Daily
//
//  Created by 최승용 on 2022/12/12.
//

import UIKit

private let serverUrl: String = "http://115.68.248.159:5001/"

func getUserInfo(userID: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
    requestGet(url: "\(serverUrl)user/info/\(userID)") { (success, data) in
        completionHandler(success, data)
    }
}

func setUserInfo(param: [String: Any]) {
    requestPost(url: "\(serverUrl)user/set", param: param)
}

func getCalendarYear(userID: String, year: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
    requestGet(url: "\(serverUrl)calendar/year/\(userID)?date=\(year)") { (success, data) in
        completionHandler(success, data)
    }
}

func getCalendarMonth(userID: String, month: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
    requestGet(url: "\(serverUrl)calendar/month/\(userID)?date=\(month)") { (success, data) in
        completionHandler(success, data)
    }
}

func getCalendarWeek(userID: String, startDay: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
    requestGet(url: "\(serverUrl)calendar/week/\(userID)?date=\(startDay)") { (success, data) in
        completionHandler(success, data)
    }
}

func getCalendarDay(userID: String, day: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
    requestGet(url: "\(serverUrl)calendar/day/\(userID)?date=\(day)") { (success, data) in
        completionHandler(success, data)
    }
}
