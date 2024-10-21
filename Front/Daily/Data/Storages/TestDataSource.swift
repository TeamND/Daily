//
//  TestDataSource.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

class TestDataSource {
    static let shared = TestDataSource()
    private var data: String = "init data"
    
    private init() { }
    
    func changeData(data: String) {
        self.data = data
    }
    func getData() -> String {
        return self.data
    }
    
    func getUserInfo(userID: String) async throws -> UserInfoModel {
        let userInfo: UserInfoModel = try await ServerNetwork.shared.request(.getUserInfo(userID: userID))
        print("userInfo is \(userInfo)")
        return userInfo
    }
}
