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
    
    func testFunc(testParam: String) {
        let testResult: Bool = repository.test(param: testParam)
        print("testResult is \(testResult)")
    }
}
