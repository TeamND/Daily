//
//  DailyApp.swift
//  Daily
//
//  Created by 최승용 on 2022/10/31.
//

import SwiftUI

@main
struct DailyApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State var isLoading: Bool = true
    @State var userInfo: UserInfo = UserInfo(uid: -1, set_startday: 0, set_language: "korea", set_dateorrepeat: "date", set_calendarstate: "month")
    @State var isDebugMode: Bool = true
    var body: some Scene {
        WindowGroup {
            if isDebugMode { DebugView() }
            else {
                if isLoading { InitView(userInfo: userInfo, isLoading: $isLoading) }
                else         { MainView(userInfo: userInfo) }
            }
        }
        .onChange(of: scenePhase) { phase in
            print("phase is ", phase)
//            switch phase {
//              case .active:
//                print("켜짐")
//              case .inactive:
//                print("꺼짐")
//              case .background:
//                print("백그라운드에서 돌아가는 중")
//              }
        }
    }
}
