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
    @Published var isAppLoaded: Bool = false
    @Published var isShowNotice: Bool = false
    
    init() {
        self.appLaunchUseCase = AppLaunchUseCase()
    }
    
    func onAppear() {
        setUserDefault()
        catchPhrase = appLaunchUseCase.getCatchPhrase()
        isShowNotice = appLaunchUseCase.checkNotice()
        if !isShowNotice { loadApp(isWait: true) }
    }
    
    func loadApp(isWait: Bool = false) {
        Task { @MainActor in
            isAppLoaded = await appLaunchUseCase.loadApp(isWait)
        }
    }
    
    private func setUserDefault() {
        UserDefaultManager.startDay = UserDefaultManager.startDay ?? 0
        UserDefaultManager.language = UserDefaultManager.language ?? "korean"
        UserDefaultManager.dateType = UserDefaultManager.dateType ?? "date"
        UserDefaultManager.calendarType = UserDefaultManager.calendarType ?? "month"
    }
}
