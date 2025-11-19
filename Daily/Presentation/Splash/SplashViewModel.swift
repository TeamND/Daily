//
//  SplashViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

final class SplashViewModel: ObservableObject {
    private let appLaunchUseCase: AppLaunchUseCase
    private let calendarUseCase: CalendarUseCase
    
    @Published var catchPhrase: String = ""
    @Published var updateNotice: String = ""
    @Published var isMainReady: Bool = false
    @Published var isMainLoaded: Bool = false
    @Published var notices: [NoticeModel] = []
    @Published var isNeedUpdate: Bool = false
    
    init() {
        let appLaunchRepository = AppLaunchRepository()
        let calendarRepository = CalendarRepository()
        
        self.appLaunchUseCase = AppLaunchUseCase(repository: appLaunchRepository)
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }

    func onAppear() {
        setUserDefault()
        Task { @MainActor in
            catchPhrase = appLaunchUseCase.getCatchPhrase()
            
            isNeedUpdate = await appLaunchUseCase.checkUpdate()
            if isNeedUpdate {
                (catchPhrase, updateNotice) = appLaunchUseCase.getUpdateNotice()
                return
            }
            
            await appLaunchUseCase.migrate()
            await appLaunchUseCase.fetch()
            await calendarUseCase.fetchHolidays()
            isMainReady = true
            
            notices = await appLaunchUseCase.getNotices()
            isMainLoaded = await appLaunchUseCase.loadMain()
        }
    }
    
    private func setUserDefault() {
        UserDefaultManager.startDay = UserDefaultManager.startDay ?? DayOfWeek.sun.index
        UserDefaultManager.language = UserDefaultManager.language ?? Languages.korean.rawValue
        UserDefaultManager.calendarType = UserDefaultManager.calendarType ?? CalendarTypes.month.rawValue
        
        UserDefaultManager.holidays = [:]
    }
}
