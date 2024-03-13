//
//  NetworkManager.swift
//  Daily
//
//  Created by 최승용 on 3/13/24.
//

import Foundation

final class NetworkManager {
    let serverUrl: String = "http://34.22.71.88:5000/"
    
    func getCalendarDay2(userID: String, day: String, complete: @escaping (HTTPResponseModel?) -> Void) {
        HTTPManager.requestGET(url: "\(serverUrl)calendar/day/\(userID)?date=\(day)") { data in
            print("start data is \(data)")
            guard let data: HTTPResponseModel = JSONConverter.decodeJson(data: data) else {
                return
            }
            complete(data)
        }
    }
    
    func getCalendarDay3(userID: String, day: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
        requestGet(url: "\(serverUrl)calendar/day/\(userID)?date=\(day)") { (success, data) in
            completionHandler(success, data)
        }
    }
}
