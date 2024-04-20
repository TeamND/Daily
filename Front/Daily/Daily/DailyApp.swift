//
//  DailyApp.swift
//  Daily
//
//  Created by 최승용 on 2022/10/31.
//

import SwiftUI

@main
struct DailyApp: App {
    @State var isLoading: Bool = true
    @StateObject var userInfo: UserInfo = UserInfo(uid: -1, set_startday: 0, set_language: "korea", set_dateorrepeat: "date", set_calendarstate: "month")
    @StateObject var userInfoViewModel: UserInfoViewModel = UserInfoViewModel()
    var body: some Scene {
        WindowGroup {
            if isLoading { InitView(userInfo: userInfo, userInfoViewModel: userInfoViewModel, isLoading: $isLoading) }
            else         { MainView(userInfo: userInfo, userInfoViewModel: userInfoViewModel) }
//            TestView()
        }
    }
}
