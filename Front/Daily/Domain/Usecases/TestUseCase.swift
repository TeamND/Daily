//
//  TestUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

class TestUseCase {
    private let repository: TestInterface
    
    init(repository: TestInterface) {
        self.repository = repository
    }
    
    func getUserInfo(userID: String) async throws -> UserInfoModel {
        let userInfo: UserInfoModel = try await repository.test(userID: userID)
        return userInfo
    }
}
