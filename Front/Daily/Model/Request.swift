//
//  Request.swift
//  Daily
//
//  Created by 최승용 on 2022/12/15.
//

import UIKit

func requestGet(url: String, completionHandler: @escaping (Bool, NSDictionary) -> Void) {
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
        
        DispatchQueue.main.async() {
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let jsonObject = object else { return }
                guard let returnData = jsonObject["data"] as? NSDictionary else { return }
                
                completionHandler(true, returnData)
            } catch let e as NSError {
                print("An error has occured while parsing JSON Obejt : \(e.localizedDescription)")
            }
        }
    }.resume()
}

func requestPost(url: String, param: [String: Any], completionHandler: @escaping (Bool, NSDictionary) -> Void) {
    let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
    
    guard let url = URL(string: url) else {
        print("Error: cannot create URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
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
        
        DispatchQueue.main.async() {
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let jsonObject = object else { return }
                guard let returnData = jsonObject["data"] as? NSDictionary else { return }
                
                completionHandler(true, returnData)
            } catch let e as NSError {
                print("An error has occured while parsing JSON Obejt : \(e.localizedDescription)")
            }
        }
    }.resume()
}
