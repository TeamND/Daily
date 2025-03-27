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
    @Published var isNeedUpdate: Bool = false
    
    init() {
        self.appLaunchUseCase = AppLaunchUseCase()
    }

    func onAppear() {
        setUserDefault()
        Task { @MainActor in
            catchPhrase = appLaunchUseCase.getCatchPhrase()
            isShowNotice = appLaunchUseCase.checkNotice()
            isNeedUpdate = await appLaunchUseCase.checkUpdate()
            // MARK: 2.0.6 한정 임시 문구
            if isNeedUpdate {
                catchPhrase = "보다 원활한 서비스 이용을 위해\n\n\t\t최신 버전으로 업데이트 해주세요."
            }
            
            if !isNeedUpdate && !isShowNotice { loadApp(isWait: true) }
        }
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
