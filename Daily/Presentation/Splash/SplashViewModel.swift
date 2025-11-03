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
    @Published var isMainReady: Bool = false
    @Published var isMainLoaded: Bool = false
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
            await appLaunchUseCase.fetch()
            
            isNeedUpdate = await appLaunchUseCase.checkUpdate()
            if isNeedUpdate {
                (catchPhrase, updateNotice) = appLaunchUseCase.getUpdateNotice()
                return
            }
            
            await appLaunchUseCase.migrate()
            isMainReady = true
            
            notices = await appLaunchUseCase.getNotices()
            isMainLoaded = await appLaunchUseCase.loadMain()
        }
    }
    
    private func setUserDefault() {
        UserDefaultManager.startDay = UserDefaultManager.startDay ?? DayOfWeek.sun.index
        UserDefaultManager.language = UserDefaultManager.language ?? Languages.korean.rawValue
        UserDefaultManager.calendarType = UserDefaultManager.calendarType ?? CalendarTypes.month.rawValue
    }
}
