//
//  UserInfo.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import Foundation

var userInfo: UserInfo = UserInfo(uid: -1, set_startday: 0, set_language: "", set_dateorrepeat: "")

class UserInfo: ObservableObject{
    @Published var uid: Int
    @Published var set_startday: Int
    @Published var set_language: String
    @Published var set_dateorrepeat: String
    
    init(uid: Int, set_startday: Int, set_language: String, set_dateorrepeat: String) {
        self.uid = uid
        self.set_startday = set_startday
        self.set_language = set_language
        self.set_dateorrepeat = set_dateorrepeat
    }
}
