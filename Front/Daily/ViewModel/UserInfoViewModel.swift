//
//  UserInfoViewModel.swift
//  Daily
//
//  Created by 최승용 on 4/4/24.
//

import Foundation

class UserInfoViewModel: ObservableObject {
    @Published var userInfo: UserInfoModel = UserInfoModel()
    
    func setUserInfo(userInfo: UserInfoModel) {
        DispatchQueue.main.async {
            self.userInfo = userInfo
        }
    }
    
    var startDay: String {
        get { return self.weeks[0] }
        set(newValue) {
            if newValue == "일" || newValue == "Sun" {
                self.userInfo.set_startday = 0
            } else {
                self.userInfo.set_startday = 1
            }
        }
    }
    var language: String {
        get { return self.userInfo.set_language == "korea" ? "한국어" : "영어" }
        set(newValue) {
            if newValue == "한국어" {
                self.userInfo.set_language = "korea"
            } else {
                self.userInfo.set_language = "english"
            }
        }
    }
    var dateOrRepeat: String {
        get { return self.userInfo.set_dateorrepeat == "date" ? "날짜" : "반복" }
        set(newValue) {
            if newValue == "날짜" {
                self.userInfo.set_dateorrepeat = "date"
            } else {
                self.userInfo.set_dateorrepeat = "repeat"
            }
        }
    }
}

extension UserInfoViewModel {
    var weeks: [String] {
        get {
            if self.userInfo.set_language == "korea" {
                if self.userInfo.set_startday == 0 {
                    return ["일", "월", "화", "수", "목", "금", "토"]
                } else {
                    return ["월", "화", "수", "목", "금", "토", "일"]
                }
            } else {
                if self.userInfo.set_startday == 0 {
                    return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                } else {
                    return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                }
            }
        }
    }
    
    var months: [String] {
        get {
            if self.userInfo.set_language == "korea" {
                return ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
            } else {
                return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            }
        }
    }
}
