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
        AddGoalPopup(userInfo: userInfo, popupInfo: popupInfo, user_uid: userInfo.uid, dateOrRepeat: userInfo.set_dateorrepeat)
        RightSideMenu(userInfo: userInfo, popupInfo: popupInfo)
    }
}
