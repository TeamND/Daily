//
//  TestRepository.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

class TestRepository: TestInterface {
    func test(userID: String) async throws -> UserInfoModel {
        return try await TestDataSource.shared.getUserInfo(userID: userID)
    }
}
