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
            guard let data = data else { return }
            guard let response = urlResponse as? HTTPURLResponse else { return }
            complete(data)
        }.resume()
    }
}
