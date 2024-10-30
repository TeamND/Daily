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
    case getCalendarYear(userID: String, year: String)
    case getCalendarMonth(userID: String, month: String)
    case getCalendarWeek(userID: String, startDay: String)
    case getCalendarDay(userID: String, day: String)
    
    // MARK: - path
    var path: String {
        switch self {
        case .getUserInfo(let userID):
            return "/user/info/\(userID)"
        case .getCalendarYear(let userID, _):
            return "/calendar/year/\(userID)"
        case .getCalendarMonth(let userID, _):
            return "/calendar/month/\(userID)"
        case .getCalendarWeek(let userID, _):
            return "/calendar/week/\(userID)"
        case .getCalendarDay(let userID, _):
            return "/calendar/day/\(userID)"
        }
    }
    
    // MARK: - method
    var method: NetworkMethod {
        switch self {
        case .getUserInfo, .getCalendarYear, .getCalendarMonth, .getCalendarWeek, .getCalendarDay:
            return .get
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
//        default:
//            return nil
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
