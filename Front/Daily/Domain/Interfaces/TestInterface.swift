//
//  TestInterface.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

protocol TestInterface {
    func test(userID: String) async throws-> UserInfoModel
}
