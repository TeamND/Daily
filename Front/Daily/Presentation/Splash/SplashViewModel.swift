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
    @Published var isAppLaunching: Bool = false
    
    init() {
        let repository = AppLaunchRepository()
        self.appLaunchUseCase = AppLaunchUseCase(repository: repository)
    }
    
    func onAppear() {
        self.subTitle = appLaunchUseCase.getSubTitle()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            self.isAppLaunching = true
        }
    }
}
