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
        
        if Date() < "2025-01-15".toDate()! { isShowNotice = true }
        else {
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 2.1, repeats: false) { timer in
                    self.isAppLoading = false
                }
            }
        }
    }
}
