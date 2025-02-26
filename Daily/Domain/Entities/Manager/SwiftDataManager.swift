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
    
    private let container: ModelContainer

    private init() {
        container = try! ModelContainer(
            for: DailyGoalModel.self, DailyRecordModel.self,
            configurations: ModelConfiguration(url: FileManager.sharedContainerURL())
        )
    }

    func getContext() -> ModelContext {
        return container.mainContext
    }
}
