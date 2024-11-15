//
//  SplashViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation
import UIKit

class SplashViewModel: ObservableObject {
    private let appLaunchUseCase: AppLaunchUseCase
    
    @Published var subTitle: String = ""
    @Published var isAppLaunching: Bool = false
    @Published var isAppLoading: Bool = true
    
    init() {
        let repository = AppLaunchRepository()
        self.appLaunchUseCase = AppLaunchUseCase(repository: repository)
    }
    
    func onAppear() {
        self.subTitle = appLaunchUseCase.getSubTitle()
        self.isAppLaunching = true
        Timer.scheduledTimer(withTimeInterval: 2.1, repeats: false) { timer in
            self.isAppLoading = false
        }
    }
    
    func getUserInfo() {
        Task {
            let phone_uid = await UIDevice.current.identifierForVendor!.uuidString
            let userInfo: UserInfoModel = try await ServerNetwork.shared.request(.getUserInfo(userID: phone_uid))
            UserDefaultManager.setUserInfo(userInfo: userInfo)
        }
    }
}
