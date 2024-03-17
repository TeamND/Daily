//
//  NetworkManager.swift
//  Daily
//
//  Created by 최승용 on 3/13/24.
//

import Foundation

private let serverUrl: String = "http://34.22.71.88:5000/"

// userInfo
//func getUserInfo(userID: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
//    requestGet(url: "\(serverUrl)user/info/\(userID)") { (success, data) in
//        completionHandler(success, data)
//    }
//}
//
//func setUserInfo(param: [String: Any]) {
//    requestPost(url: "\(serverUrl)user/set", param: param)
//}
func getUserInfo2(userID: String, complete: @escaping (getUserInfoModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)user/info/\(userID)") { data in
        guard let data: getUserInfoModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}

// calendar
//func getCalendarYear(userID: String, year: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
//    requestGet(url: "\(serverUrl)calendar/year/\(userID)?date=\(year)") { (success, data) in
//        completionHandler(success, data)
//    }
//}
//
//func getCalendarMonth(userID: String, month: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
//    requestGet(url: "\(serverUrl)calendar/month/\(userID)?date=\(month)") { (success, data) in
//        completionHandler(success, data)
//    }
//}
//
//func getCalendarWeek(userID: String, startDay: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
//    requestGet(url: "\(serverUrl)calendar/week/\(userID)?date=\(startDay)") { (success, data) in
//        completionHandler(success, data)
//    }
//}
//
//func getCalendarDay(userID: String, day: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
//    requestGet(url: "\(serverUrl)calendar/day/\(userID)?date=\(day)") { (success, data) in
//        completionHandler(success, data)
//    }
//}
func getCalendarWeek2(userID: String, startDay: String, complete: @escaping (getCalendarWeekModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/week/\(userID)?date=\(startDay)") { data in
        guard let data: getCalendarWeekModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}
func getCalendarDay2(userID: String, day: String, complete: @escaping (getCalendarDayModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/day/\(userID)?date=\(day)") { data in
        guard let data: getCalendarDayModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}

// goal
//func addGoal(goal: Goal) {
//    let requestData: [String: Any] = [
//        "user_uid": goal.user_uid,
//        "content": goal.content,
//        "symbol": goal.symbol,
//        "start_date": goal.start_date,
//        "end_date": goal.end_date,
//        "cycle_type": goal.cycle_type,
//        "cycle_date": goal.cycle_date,
//        "type": goal.type,
//        "goal_count": goal.goal_count,
//        "goal_time": goal.goal_time
//    ]
//    requestPost(url: "\(serverUrl)goal/", param: requestData)
//}
func increaseCount(recordUID: String, complete: @escaping (increaseCountModel) -> Void) {
    HTTPManager.requestPUT(url: "\(serverUrl)goal/count/\(recordUID)", encodingData: Data()) { data in
        guard let data: increaseCountModel = JSONConverter.decodeJson(data: data) else {
            guard let data: ErrorModel = JSONConverter.decodeJson(data: data) else {
                return
            }
            print("data decoding error data is. \(data)")
            return
        }
        complete(data)
    }
}
