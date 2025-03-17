//
//  AppLaunchUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

final class AppLaunchUseCase {
    func getCatchPhrase() -> String {
        guard let language = Languages(rawValue: UserDefaultManager.language ?? "korean") else { return "" }
        switch language {
        case .korean:
            return "데일리를 관리하는\n가장 체계적인 스케쥴러"
        case .english:
            return "To organize your daily life,\nuse the most structured scheduler"
        }
    }
    
    func checkNotice() -> Bool {
        return Date() < "2025-01-15".toDate()!  // TODO: 추후 수정
    }
    
    func loadApp(_ isWait: Bool = true) async -> Bool {
        if isWait { try? await Task.sleep(nanoseconds: 2_100_000_000) }
        return true
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
}

