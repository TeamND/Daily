//
//  GeneralServices.swift
//  Daily
//
//  Created by seungyooooong on 11/25/24.
//

import Foundation

class GeneralServices {
    static let shared = GeneralServices()
    private init() { }
    
    let minimumGoalCount: Int = 1
    let maximumGoalCount: Int = 10
}
