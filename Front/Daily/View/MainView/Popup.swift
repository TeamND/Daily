//
//  Popup.swift
//  Daily
//
//  Created by 최승용 on 2022/11/21.
//

import SwiftUI

struct Popup: View {
    @StateObject var userInfo: UserInfo
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        PopupDim(popupInfo: popupInfo)
        AddGoalPopup(popupInfo: popupInfo, goal: Goal(user_uid: userInfo.uid, cycle_type: userInfo.set_dateorrepeat))
        RightSideMenu(userInfo: userInfo, popupInfo: popupInfo)
    }
}
