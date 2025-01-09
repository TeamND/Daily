//
//  NetworkError.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

enum NetworkError: Error {
    case request
    case parse
    case server
    case unknown
    
    var description: String {
        switch self {
        case .request:
            return "잘못된 요청입니다"
        case .parse:
            return "데이터 형식이 잘못되었습니다"
        case .server:
            return "서버 에러 입니다"
        case .unknown:
            return "문제가 발생했습니다"
        }
    }
}
