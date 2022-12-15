//
//  Week.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import Foundation

func weeks() -> [String] {
    if userInfo.set_language == "korea" {
        if userInfo.set_startday == 0 {
            return ["일", "월", "화", "수", "목", "금", "토"]
        } else {
            return ["월", "화", "수", "목", "금", "토", "일"]
        }
    } else {
        if userInfo.set_startday == 0 {
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        } else {
            return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        }
    }
}
