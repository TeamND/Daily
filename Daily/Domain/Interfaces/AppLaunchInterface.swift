//
//  AppLaunchInterface.swift
//  Daily
//
//  Created by seungyooooong on 7/1/25.
//

import Foundation

protocol AppLaunchInterface {
    func getGoals() async -> [DailyGoalModel]?
    
    func updateData() async
}
