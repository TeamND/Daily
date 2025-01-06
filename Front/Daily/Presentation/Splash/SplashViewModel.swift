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
    
    init() {
        let repository = AppLaunchRepository()
        self.appLaunchUseCase = AppLaunchUseCase(repository: repository)
    }
    
    func onAppear() {
        self.subTitle = appLaunchUseCase.getSubTitle()
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 2.1, repeats: false) { timer in
                self.isAppLoading = false
            }
        }
    }
}
