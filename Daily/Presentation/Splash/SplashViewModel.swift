//
//  SplashViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

class SplashViewModel: ObservableObject {
    private let appLaunchUseCase: AppLaunchUseCase
    
    @Published var subTitle: String = ""
    @Published var isAppLoading: Bool = true
    @Published var isShowNotice: Bool = false
    
    init() {
        let repository = AppLaunchRepository()
        self.appLaunchUseCase = AppLaunchUseCase(repository: repository)
    }
    
    func onAppear() {
        self.subTitle = appLaunchUseCase.getSubTitle()
        setUserDefault()
        
        if Date() < "2025-01-15".toDate()! { isShowNotice = true }
        else {
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 2.1, repeats: false) { timer in
                    self.isAppLoading = false
                }
            }
        }
    }
    
    func setUserDefault() {
        UserDefaultManager.startDay = UserDefaultManager.startDay ?? 0
        UserDefaultManager.language = UserDefaultManager.language ?? "korean"
        UserDefaultManager.dateType = UserDefaultManager.dateType ?? "date"
        UserDefaultManager.calendarType = UserDefaultManager.calendarType ?? "month"
    }
}
