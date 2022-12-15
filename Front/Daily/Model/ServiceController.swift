//
//  ServiceController.swift
//  Daily
//
//  Created by 최승용 on 2022/12/12.
//

import UIKit

private let serverUrl: String = "http://115.68.248.159:5001/"

func getUserInfo(userID: String, completionHandler: @escaping (Bool, NSDictionary) -> Void) {
    requestGet(url: "\(serverUrl)user/info/\(userID)") { (success, data) in
        completionHandler(success, data)
    }
}

func request(_ url: String, _ method: String, _ param: [String: Any]? = nil, completionHandler: @escaping (Bool, NSDictionary) -> Void) {
    if method == "GET" {
        requestGet(url: url) { (success, data) in
            completionHandler(success, data)
        }
    }
    else {
        requestPost(url: url, method: method, param: param!) { (success, data) in
            completionHandler(success, data)
        }
    }
}
