//
//  NetworkEndpoint.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

protocol NetworkEndpoint {
    var serverURL: URL? { get }
    var path: String { get }
    var method: NetworkMethod { get }
    var parameters: [URLQueryItem]? { get }
    var header: [String: String]? { get }
    var body: Encodable? { get }
}

enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ServerEndpoint: NetworkEndpoint {
    var serverURL: URL? { URL(string: "http://43.202.215.185:5000") }
    // MARK: - APIs
    case getUserInfo(userID: String)
    case getServerVersion
    case getCalendarYear(userID: String, year: String)
    case getCalendarMonth(userID: String, month: String)
    case getCalendarWeek(userID: String, startDay: String)
    case getCalendarDay(userID: String, day: String)
    case increaseCount(recordID: String)
    case removeRecord(recordID: String)
    case removeRecordAll(goalID: String)
    case removeGoal(goalID: String)
    
    // MARK: - path
    var path: String {
        switch self {
        case .getUserInfo(let userID):
            return "/user/info/\(userID)"
        case .getServerVersion:
            return "/user/version/\(String(System.appVersion!)))"
        case .getCalendarYear(let userID, _):
            return "/calendar/year/\(userID)"
        case .getCalendarMonth(let userID, _):
            return "/calendar/month/\(userID)"
        case .getCalendarWeek(let userID, _):
            return "/calendar/week/\(userID)"
        case .getCalendarDay(let userID, _):
            return "/calendar/day/\(userID)"
        case .increaseCount(let recordID):
            return "/goal/count/\(recordID)"
        case .removeRecord(let recordID):
            return "/record/\(recordID)"
        case .removeRecordAll(let goalID):
            return "/goal/removeRecordAll/\(goalID)"
        case .removeGoal(let goalID):
            return "/goal/\(goalID)"
        }
    }
    
    // MARK: - method
    var method: NetworkMethod {
        switch self {
        case .getUserInfo, .getServerVersion, .getCalendarYear, .getCalendarMonth, .getCalendarWeek, .getCalendarDay:
            return .get
        case .increaseCount:
            return .put
        case .removeRecord, .removeRecordAll, .removeGoal:
            return .delete
        }
    }
    
    // MARK: - parameters
    var parameters: [URLQueryItem]? {
        switch self {
        case .getUserInfo:  // TODO: app version check api 생성 후 삭제
            return [.init(name: "appVersion", value: String(System.appVersion!))]
        case .getCalendarYear(_, let year):
            return [.init(name: "date", value: year)]
        case .getCalendarMonth(_, let month):
            return [.init(name: "date", value: month)]
        case .getCalendarWeek(_, let startDay):
            return [.init(name: "date", value: startDay)]
        case .getCalendarDay(_, let day):
            return [.init(name: "date", value: day)]
        default:
            return nil
        }
    }
    
    // MARK: - header
    var header: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: - body
    var body: (any Encodable)? {
        switch self {
        default:
            return nil
        }
    }
}
