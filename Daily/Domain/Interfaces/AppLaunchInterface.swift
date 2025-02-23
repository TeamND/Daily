//
//  AppLaunchInterface.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import Foundation

protocol AppLaunchInterface {
    func getCatchPhrase() -> String
    func checkNotice() -> Bool
    func loadApp(_ isWait: Bool) async -> Bool
}
