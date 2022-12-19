//
//  Request.swift
//  Daily
//
//  Created by 최승용 on 2022/12/15.
//

import UIKit
import Alamofire

func requestGet(url: String, completionHandler: @escaping (Bool, [String: Any]) -> Void) {
    AF.request(url).responseJSON() { response in
        switch response.result {
        case .success:
            if let data = try! response.result.get() as? [String: Any] {
                completionHandler(true, data["data"] as! [String : Any])
            }
        case .failure(let error):
            print("Error: \(error)")
            return
        }
    }
}

func requestPost(url: String, param: [String: Any]) {
    AF.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody).responseJSON() { response in
        switch response.result {
        case .success:
            if let data = try! response.result.get() as? [String: Any] {
//                print(data)
            }
        case .failure(let error):
            print("Error: \(error)")
            return
        }
    }
}
