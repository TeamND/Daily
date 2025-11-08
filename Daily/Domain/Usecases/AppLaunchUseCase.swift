//
//  AppLaunchUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

final class AppLaunchUseCase {
    private let repository: AppLaunchInterface
    
    init(repository: AppLaunchInterface) {
        self.repository = repository
    }
}

extension AppLaunchUseCase {
    func getCatchPhrase() -> String {
        let language = Languages(rawValue: UserDefaultManager.language ?? "korean") ?? .korean
        switch language {
        case .korean:
            return "매일을 더 체계적으로"
        case .english:
            return "Struct your\nevery day"
        }
    }
    
    func getNotices() async -> [NoticeModel] {
        if let ignoreNoticeDate = UserDefaultManager.ignoreNoticeDate, ignoreNoticeDate >= Date(format: .daily) { return [] }
        
        var notices = [
            NoticeModel(
                id: 0, type: .image, image: "daily_2.0_update"
            )
        ]
        
        // MARK: sheet animation을 고려해 0.5초 추가 딜레이
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        return notices
    }
    
    func checkUpdate() async -> Bool {
        do {
            let storeVersion = try await System.getStoreVersion().split(separator: ".").map {$0}
            let appVersion = System.appVersion!.split(separator: ".").map {$0}
            
            return ((storeVersion[0] > appVersion[0]) || (storeVersion[1] > appVersion[1]))
        } catch {
            return false
        }
    }
    
    func getUpdateNotice() -> (String, String) {
        let language = Languages(rawValue: UserDefaultManager.language ?? "korean") ?? .korean
        switch language {
        case .korean:
            return ("업데이트 알림", "보다 원활한 서비스 이용을 위해\n최신 버전으로 업데이트 해주세요.")
        case .english:
            return ("Update Available", "To ensure a smoother experience,\nplease update to the latest version.")
        }
    }
}

extension AppLaunchUseCase {
    func fetch() async {
        await TaskQueueManager.shared.add { [weak self] in
            guard let self else { return }
            
            var count = 0
            while count < 10 {
                if let goals = await repository.getGoals(), goals.isEmpty {
                    count += 1
                    try? await Task.sleep(nanoseconds: 500_000_000)
                } else { break }
                
                if let records = await repository.getRecords(), records.isEmpty {
                    count += 1
                    try? await Task.sleep(nanoseconds: 500_000_000)
                } else { break }
            }
            
            await repository.updateData()
        }
    }
    
    func migrate() async {
        let beforeVersion = UserDefaultManager.beforeVersion
        UserDefaultManager.beforeVersion = System.appVersion
        
        await TaskQueueManager.shared.add { [weak self] in
            guard let self else { return }
            
            if isVersionAtMost("2.0.10", comparedTo: beforeVersion) {
                await goalTypeMigrate()
            }
            
            if isVersionAtMost("2.1.4", comparedTo: beforeVersion) {
                await cloudMigrate()
            }
        }
    }
    
    func isVersionAtMost(_ baseVersion: String, comparedTo comparisonVersion: String?) -> Bool {
        guard let comparisonVersion = comparisonVersion else { return true }
        
        let baseComponents = baseVersion.split(separator: ".").compactMap { Int($0) }
        let comparisonComponents = comparisonVersion.split(separator: ".").compactMap { Int($0) }

        let maxLength = max(baseComponents.count, comparisonComponents.count)

        for i in 0 ..< maxLength {
            let base = i < baseComponents.count ? baseComponents[i] : 0
            let comparison = i < comparisonComponents.count ? comparisonComponents[i] : 0

            if comparison > base {
                return false
            } else if comparison < base {
                return true
            }
        }

        return true
    }
    
    func goalTypeMigrate() async {
        guard let goals = await repository.getLegacyGoals() else { return }
        
        for goal in goals {
            if goal.type == .check {
                goal.type = .count
            }
        }
        
        await repository.updateLegacyData()
    }
    
    func cloudMigrate() async {
        guard let goals = await repository.getLegacyGoals() else { return }
        
        for goal in goals {
            let copiedGoal = goal.copy()
            copiedGoal.records = goal.records?.map { $0.copy(goal: copiedGoal) } ?? []
            for record in goal.records ?? [] { await repository.deleteLegacyRecord(record: record) }
            await repository.addGoal(goal: copiedGoal)
            await repository.deleteLegacyGoal(goal: goal)
        }
        
        await repository.updateData()
    }
    
    func loadMain() async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
}

