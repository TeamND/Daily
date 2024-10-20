//
//  TestRepository.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

class TestRepository: TestInterface {
    func test(param: String) -> Bool {
        return TestDataSource.shared.getData() == param
    }
}
