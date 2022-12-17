//
//  Menu.swift
//  Daily
//
//  Created by 최승용 on 2022/11/25.
//

import Foundation

class Menu: ObservableObject, Identifiable {
    @Published var id: String
    @Published var isSelected: Bool
    @Published var title: String
    @Published var option: String
    var selectedOption: String {
        get {
            return self.option
        }
        set(newVal) {
            switch (id) {
            case "set_language":
                if newVal == "한국어" {
                    setUserInfo(param: ["uid": userInfo.uid, "set_language": "korea"])
                } else {
                    setUserInfo(param: ["uid": userInfo.uid, "set_language": "english"])
                }
            case "set_startday":
                if newVal == "일요일" { print("0") }
                else { print("1") }
            case "set_dateorrepeat":
                if newVal == "날짜" { print("date") }
                else { print("repeat") }
            default:
                break
            }
            self.option = newVal
        }
    }
    @Published var options: [[String]] = [["한국어", "영어"], ["일요일", "월요일"], ["날짜", "요일"]]
    
    init(id: String, isSelected: Bool, title: String, option: String) {
        self.id = id
        self.isSelected = isSelected
        self.title = title
        self.option = option
    }
}
