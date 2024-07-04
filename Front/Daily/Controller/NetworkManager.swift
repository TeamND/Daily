//
//  NetworkManager.swift
//  Daily
//
//  Created by 최승용 on 3/13/24.
//

import SwiftUI

private let serverUrl: String = "http://43.202.215.185:5000/"   // aws

func printDataToString(data: Data) {
    print(String(decoding: data, as: UTF8.self))
}

// MARK: - userInfo
func getUserInfo(userID: String, complete: @escaping (getUserInfoModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)user/info/\(userID)?appVersion=\(String(System.appVersion!))") { data in
        guard let data: getUserInfoModel = JSONConverter.decodeJson(data: data) else {
            complete(getUserInfoModel())
            return
        }
        complete(data)
    }
}

// MARK: - calendar
func getCalendarYear(userID: String, year: String, complete: @escaping (getCalendarYearModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/year/\(userID)?date=\(year)") { data in
        guard let data: getCalendarYearModel = JSONConverter.decodeJson(data: data) else {
            complete(getCalendarYearModel())
            return
        }
        complete(data)
    }
}
func getCalendarMonth(userID: String, month: String, complete: @escaping (getCalendarMonthModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/month/\(userID)?date=\(month)") { data in
        guard let data: getCalendarMonthModel = JSONConverter.decodeJson(data: data) else {
            complete(getCalendarMonthModel())
            return
        }
        complete(data)
    }
}
func getCalendarWeek(userID: String, startDay: String, complete: @escaping (getCalendarWeekModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/week/\(userID)?date=\(startDay)") { data in
        guard let data: getCalendarWeekModel = JSONConverter.decodeJson(data: data) else {
            complete(getCalendarWeekModel())
            return
        }
        complete(data)
    }
}
func getCalendarDay(userID: String, day: String, complete: @escaping (getCalendarDayModel) -> Void) {
    HTTPManager.requestGET(url: "\(serverUrl)calendar/day/\(userID)?date=\(day)") { data in
        guard let data: getCalendarDayModel = JSONConverter.decodeJson(data: data) else {
            complete(getCalendarDayModel())
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
            complete(increaseCountModel())
            return
        }
        complete(data)
    }
}
func startTimer(startTimerRequestModel: startTimerRequestModel, complete: @escaping (startTimerResponseModel) -> Void) {
    guard let encodingData: Data = JSONConverter.encodeJson(param: startTimerRequestModel) else {
        return
    }
    HTTPManager.requestPUT(url: "\(serverUrl)goal/timer/\(startTimerRequestModel.uid)", encodingData: encodingData) { data in
        guard let data: startTimerResponseModel = JSONConverter.decodeJson(data: data) else {
            complete(startTimerResponseModel())
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
func modifyGoal(modifyGoalModel: modifyGoalModel, complete: @escaping (ResponseModel) -> Void) {
    guard let encodingData: Data = JSONConverter.encodeJson(param: modifyGoalModel) else {
        return
    }
    HTTPManager.requestPUT(url: "\(serverUrl)goal/\(modifyGoalModel.uid)", encodingData: encodingData) { data in
        guard let data: ResponseModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}

// MARK: - record
func removeRecord(recordUID: String, complete: @escaping (ResponseModel) -> Void) {
    HTTPManager.requestDELETE(url: "\(serverUrl)record/\(recordUID)", encodingData: Data()) { data in
        guard let data: ResponseModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}
func removeRecordAll(goalUID: String, complete: @escaping (ResponseModel) -> Void) {
    HTTPManager.requestDELETE(url: "\(serverUrl)record/deleteAll/\(goalUID)", encodingData: Data()) { data in
        guard let data: ResponseModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}
func modifyRecord(modifyRecordModel: modifyRecordModel, complete: @escaping (ResponseModel) -> Void) {
    guard let encodingData: Data = JSONConverter.encodeJson(param: modifyRecordModel) else {
        return
    }
    HTTPManager.requestPUT(url: "\(serverUrl)record/\(modifyRecordModel.uid)", encodingData: encodingData) { data in
        guard let data: ResponseModel = JSONConverter.decodeJson(data: data) else {
            return
        }
        complete(data)
    }
}
