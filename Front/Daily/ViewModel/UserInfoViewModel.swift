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
}
