//
//  ServiceController.swift
//  Daily
//
//  Created by 최승용 on 2022/12/12.
//

import UIKit

struct Response<T: Codable>: Codable {
    let code: String
    let message: String
    let data: T
}

struct MyUserInfo: Codable {
    let uid: Int
    let set_startday: Int
    let set_language: String
    let set_dateorrepeat: String
}

/* Body가 없는 요청 */
func requestGet(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
    guard let url = URL(string: url) else {
        print("Error: cannot create URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
//        guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
//            print("Error: HTTP request failed")
//            return
//        }
        guard let output = try? JSONDecoder().decode(Response<MyUserInfo>.self, from: data) else {
            print("Error: JSON Data Parsing failed")
            return
        }
        
        completionHandler(true, output)
    }.resume()
}

/* Body가 있는 요청 */
func requestPost(url: String, method: String, param: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
    let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
    
    guard let url = URL(string: url) else {
        print("Error: cannot create URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = sendData
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
//        guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
//            print("Error: HTTP request failed")
//            return
//        }
        guard let output = try? JSONDecoder().decode(Response<MyUserInfo>.self, from: data) else {
            print("Error: JSON Data Parsing failed")
            return
        }
        
        completionHandler(true, output.message)
    }.resume()
}

/* 메소드별 동작 분리 */
func request(_ url: String, _ method: String, _ param: [String: Any]? = nil, completionHandler: @escaping (Bool, Any) -> Void) {
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
