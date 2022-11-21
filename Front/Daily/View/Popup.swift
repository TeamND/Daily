//
//  Popup.swift
//  Daily
//
//  Created by 최승용 on 2022/11/21.
//

import SwiftUI

struct Popup: View {
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        PopupDim(popupInfo: popupInfo)
        AddGoalPopup(popupInfo: popupInfo)
        RightSideMenu(popupInfo: popupInfo)
    }
}
