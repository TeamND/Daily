//
//  AppLaunchUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

class AppLaunchUseCase {
    private let repository: AppLaunchInterface
    
    init(repository: AppLaunchInterface) {
        self.repository = repository
    }
    
    func getSubTitle() -> String {
        return repository.getSubTitle()
    }
    func setSubTitle(subTitle: String) {
        repository.setSubTitle(subTitle: subTitle)
    }
}

