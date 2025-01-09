//
//  GoalUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

class GoalUseCase {
    private let repository: GoalInterface
    
    init(repository: GoalInterface) {
        self.repository = repository
    }
}
