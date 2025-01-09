//
//  AppLaunchRepository.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

class AppLaunchRepository: AppLaunchInterface {
    func getSubTitle() -> String {
        return SplashDataSource.shared.getSubTitle()
    }
    func setSubTitle(subTitle: String) {
        SplashDataSource.shared.setSubTitle(subTitle: subTitle)
    }
}
