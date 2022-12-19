//
//  MainView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/05.
//

import SwiftUI

struct MainView: View {
    @StateObject var userInfo: UserInfo
    @State private var popupInfo: PopupInfo = PopupInfo()
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                MainHeader(userInfo: userInfo, popupInfo: popupInfo)
                    .frame(height: 40)
                MainCalendar(userInfo: userInfo)
            }
            Popup(userInfo: userInfo, popupInfo: popupInfo)
        }
        .accentColor(.mint)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userInfo: UserInfo(uid: 5, set_startday: 0, set_language: "korea", set_dateorrepeat: "date", set_calendarstate: "month"))
    }
}
