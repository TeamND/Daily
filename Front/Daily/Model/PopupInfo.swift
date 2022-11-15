//
//  AppInfo.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import Foundation

class PopupInfo: ObservableObject {
    @Published var showPopup: Bool = false
    @Published var showMenu: Bool = true
}

extension PopupInfo {
    func showPopup(isPopup: Bool = true) {
        if isPopup { showPopup = true }
        else       { showMenu =  true }
    }
    func closePopup(isPopup: Bool = true) {
        if isPopup { showPopup = false }
        else       { showMenu =  false }
    }
}
