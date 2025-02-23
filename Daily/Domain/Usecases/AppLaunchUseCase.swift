//
//  AppLaunchUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

final class AppLaunchUseCase {
    private let repository: AppLaunchInterface
    
    init(repository: AppLaunchInterface) {
        self.repository = repository
    }
    
    func getCatchPhrase() -> String {
        return repository.getCatchPhrase()
    }
    
    func checkNotice() -> Bool {
        return repository.checkNotice()
    }
    
    func loadApp(_ isWait: Bool = true) async -> Bool {
        return await repository.loadApp(isWait)
    }
}

