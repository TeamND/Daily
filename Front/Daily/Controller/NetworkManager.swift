//
//  NetworkManager.swift
//  Daily
//
//  Created by 최승용 on 3/13/24.
//

import Foundation
import SwiftUI

private let serverUrl: String = "http://34.22.71.88:5000/"

// MARK: - userInfo
func getUserInfo(userID: String, complete: @escaping (getUserInfoModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)user/info/\(userID)") { data in
        guard let data: getUserInfoModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}

// MARK: - calendar
func getCalendarYear(userID: String, year: String, complete: @escaping (getCalendarYearModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/year/\(userID)?date=\(year)") { data in
        guard let data: getCalendarYearModel = JSONConverter.decodeJson(data: data) else {
            guard let data: ResponseModel = JSONConverter.decodeJson(data: data) else {
                return
            }
            print("data decoding error data is. \(data)")
            return
        }
        complete(data)
    }
}
func getCalendarMonth(userID: String, month: String, complete: @escaping (getCalendarMonthModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/month/\(userID)?date=\(month)") { data in
        guard let data: getCalendarMonthModel = JSONConverter.decodeJson(data: data) else {
            guard let data: ResponseModel = JSONConverter.decodeJson(data: data) else {
                return
            }
            print("data decoding error data is. \(data)")
            return
        }
        complete(data)
    }
}
func getCalendarWeek(userID: String, startDay: String, complete: @escaping (getCalendarWeekModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/week/\(userID)?date=\(startDay)") { data in
        guard let data: getCalendarWeekModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}
func getCalendarDay(userID: String, day: String, complete: @escaping (getCalendarDayModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/day/\(userID)?date=\(day)") { data in
        guard let data: getCalendarDayModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}

// MARK: - goal
func addGoal(goal: GoalModel, complete: @escaping (ResponseModel) -> Void) {
    guard let encodingData: Data = JSONConverter.encodeJson(param: goal) else {
        return
    }
    HTTPManager.requestPOST(url: "\(serverUrl)goal", encodingData: encodingData) { data in
        guard let data: ResponseModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}
func increaseCount(recordUID: String, complete: @escaping (increaseCountModel) -> Void) {
    HTTPManager.requestPUT(url: "\(serverUrl)goal/count/\(recordUID)", encodingData: Data()) { data in
        guard let data: increaseCountModel = JSONConverter.decodeJson(data: data) else {
            guard let data: ResponseModel = JSONConverter.decodeJson(data: data) else {
                return
            }
            print("data decoding error data is. \(data)")
            return
        }
        complete(data)
    }
}
func deleteGoal(goalUID: String, complete: @escaping (ResponseModel) -> Void) {
    HTTPManager.requestDELETE(url: "\(serverUrl)goal/\(goalUID)", encodingData: Data()) { data in
        guard let data: ResponseModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}

// MARK: - handle error

func terminateApp() {
    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        exit(0)
    }
}
