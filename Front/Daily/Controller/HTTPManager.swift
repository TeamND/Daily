//
//  HTTPManager.swift
//  Daily
//
//  Created by 최승용 on 3/13/24.
//

import Foundation
//import os

final class HTTPManager {
    static func requestGET(url: String, complete: @escaping (Data) -> ()) {
        guard let requestURL = URL(string: url) else { return }
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data = data else {
                complete(JSONConverter.encodeJson(param: ResponseModel())!)
                return
            }
            if urlResponse is HTTPURLResponse {
                complete(data)
            } else { return }
        }.resume()
    }
    
    static func requestPOST(url: String, encodingData: Data, complete: @escaping (Data) -> ()) {
        request(url: url, httpMethod: "POST", encodingData: encodingData) { data in
            complete(data)
        }
    }
    
    static func requestPUT(url: String, encodingData: Data, complete: @escaping (Data) -> ()) {
        request(url: url, httpMethod: "PUT", encodingData: encodingData) { data in
            complete(data)
        }
    }
    
    static func requestDELETE(url: String, encodingData: Data, complete: @escaping (Data) -> ()) {
        request(url: url, httpMethod: "DELETE", encodingData: encodingData) { data in
            complete(data)
        }
    }
    
    static func request(url: String, httpMethod: String, encodingData: Data, complete: @escaping (Data) -> ()) {
        guard let requestURL = URL(string: url) else { return }
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = encodingData
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue("\(encodingData.count)", forHTTPHeaderField: "Content-Length")
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data = data else { return }
            if urlResponse is HTTPURLResponse {
                complete(data)
            } else { return }
        }.resume()
    }
}
