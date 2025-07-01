//
//  AppLaunchRepository.swift
//  Daily
//
//  Created by seungyooooong on 7/1/25.
//

import Foundation

final class AppLaunchRepository: AppLaunchInterface {
    func getGoals() async -> [DailyGoalModel]? {
        await DailyDataSource.shared.getGoals()
    }
    
    func updateData() async {
        await DailyDataSource.shared.updateData()
    }
}
