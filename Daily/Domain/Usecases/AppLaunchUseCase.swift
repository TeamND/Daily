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
    
    func checkNotice() -> Bool {
        return Date() < "2025-01-15".toDate()!  // TODO: 추후 수정
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
    func migrate() async {
        let beforeVersion = UserDefaultManager.beforeVersion
        UserDefaultManager.beforeVersion = System.appVersion
        
        await TaskQueueManager.shared.add { [weak self] in
            guard let self else { return }
            
            if isVersionAtMost("2.0.10", comparedTo: beforeVersion) {
                await goalTypeMigrate()
            }
            
            await repository.updateData()
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
        guard let goals = await repository.getGoals() else { return }
        
        for goal in goals {
            if goal.type == .check {
                goal.type = .count
            }
        }
    }
    
    func loadApp(_ isWait: Bool = true) async -> Bool {
        if isWait { try? await Task.sleep(nanoseconds: 1_000_000_000) }
        return true
    }
}

