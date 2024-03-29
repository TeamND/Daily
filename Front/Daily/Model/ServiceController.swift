//
//  ServiceController.swift
//  Daily
//
//  Created by 최승용 on 2022/12/12.
//

import UIKit

private let serverUrl: String = "http://34.22.71.88:5000/"

// userInfo
func getUserInfo(userID: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
    requestGet(url: "\(serverUrl)user/info/\(userID)") { (success, data) in
        completionHandler(success, data)
    }
}

func setUserInfo(param: [String: Any]) {
    requestPost(url: "\(serverUrl)user/set", param: param)
}

// calendar
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

// goal
func addGoal(goal: Goal) {
    let requestData: [String: Any] = [
        "user_uid": goal.user_uid,
        "content": goal.content,
        "symbol": goal.symbol,
        "start_date": goal.start_date,
        "end_date": goal.end_date,
        "cycle_type": goal.cycle_type,
        "cycle_date": goal.cycle_date,
        "type": goal.type,
        "goal_count": goal.goal_count,
        "goal_time": goal.goal_time
    ]
    requestPost(url: "\(serverUrl)goal/", param: requestData)
}
