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
    
    func getRecords() async -> [DailyRecordModel]? {
        await DailyDataSource.shared.getRecords()
    }
    
    func updateData() async {
        await DailyDataSource.shared.updateData()
    }
}
