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
    
    @Published var isNeedUpdate: Bool = false
    @Published var isMainReady: Bool = false
    @Published var isMainLoaded: Bool = false
    @Published var notices: [NoticeModel] = []
    
    init() {
        let appLaunchRepository = AppLaunchRepository()
        let calendarRepository = CalendarRepository()
        
        self.appLaunchUseCase = AppLaunchUseCase(repository: appLaunchRepository)
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }

    func onAppear() {
        Task { @MainActor in
            isNeedUpdate = await appLaunchUseCase.checkUpdate()
            if isNeedUpdate { return }
            
            await appLaunchUseCase.migrate()
            await appLaunchUseCase.fetch()
            await calendarUseCase.fetchHolidays(isReset: true)
            isMainReady = true
            
            notices = await appLaunchUseCase.getNotices()
            isMainLoaded = await appLaunchUseCase.loadMain()
        }
    }
}
