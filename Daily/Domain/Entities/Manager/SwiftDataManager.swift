//
//  SwiftDataManager.swift
//  Daily
//
//  Created by seungyooooong on 2/24/25.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    let container: ModelContainer

    private init() {
        container = try! ModelContainer(
            for: DailyGoalModel.self, DailyRecordModel.self,
            configurations: ModelConfiguration(
                groupContainer: .identifier("group.com.seungyong96.Daily"),
                cloudKitDatabase: .private("iCloud.com.seungyong96.Daily")
            )
        )
    }

    func getContext() -> ModelContext {
        return container.mainContext
    }
}
