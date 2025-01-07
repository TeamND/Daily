//
//  ServerResponse.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

struct ServerResponse<T: Decodable>: Decodable {
    let code: String
    let message: String
    let data: T?
}

struct EmptyData: Decodable { }
