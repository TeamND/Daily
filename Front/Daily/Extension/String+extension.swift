//
//  String+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

// MARK: - Date
extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func toDateOfSetTime() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: self)!
    }
}

// MARK: - Symbol
extension String {  // TODO: Symbol property로 추후 수정
    func toSymbol() -> Symbol? {
        switch self {
        case "체크":
            return .체크
        case "운동":
            return .운동
        case "런닝":
            return .런닝
        case "공부":
            return .공부
        case "키보드":
            return .키보드
        case "하트":
            return .하트
        case "별":
            return .별
        case "커플":
            return .커플
        case "모임":
            return .모임
        default:
            return nil
        }
    }
}
