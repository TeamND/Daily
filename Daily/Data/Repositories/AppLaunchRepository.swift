//
//  AppLaunchRepository.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

final class AppLaunchRepository: AppLaunchInterface {
    func getCatchPhrase() -> String {
        SplashDataSource.shared.getCatchPhrase()
    }
    func checkNotice() -> Bool {
        SplashDataSource.shared.checkNotice()
    }
    func loadApp(_ isWait: Bool = true) async -> Bool {
        await SplashDataSource.shared.loadApp(isWait)
    }
}
