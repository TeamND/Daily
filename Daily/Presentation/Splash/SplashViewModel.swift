//
//  SplashViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

final class SplashViewModel: ObservableObject {
    private let appLaunchUseCase: AppLaunchUseCase
    
    @Published var catchPhrase: String = ""
    @Published var updateNotice: String = ""
    @Published var isAppLoaded: Bool = false
    @Published var notices: [NoticeModel] = []
    @Published var isNeedUpdate: Bool = false
    
    init() {
        let appLaunchRepository = AppLaunchRepository()
        self.appLaunchUseCase = AppLaunchUseCase(repository: appLaunchRepository)
    }

    func onAppear() {
        setUserDefault()
        Task { @MainActor in
            catchPhrase = appLaunchUseCase.getCatchPhrase()
            notices = appLaunchUseCase.getNotices()
            isNeedUpdate = await appLaunchUseCase.checkUpdate()
            
            if isNeedUpdate { (catchPhrase, updateNotice) = appLaunchUseCase.getUpdateNotice() }
            else if notices.isEmpty { loadApp(isWait: true) }
        }
    }
    
    func loadApp(isWait: Bool = false) {
        Task { @MainActor in
            await appLaunchUseCase.migrate()
            
            isAppLoaded = await appLaunchUseCase.loadApp(isWait)
        }
    }
    
    private func setUserDefault() {
        UserDefaultManager.startDay = UserDefaultManager.startDay ?? 0
        UserDefaultManager.language = UserDefaultManager.language ?? "korean"
        UserDefaultManager.calendarType = UserDefaultManager.calendarType ?? "month"
    }
}
