//
//  DailyApp.swift
//  Daily
//
//  Created by 최승용 on 2022/10/31.
//

import SwiftUI

@main
struct DailyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var isLoading: Bool = true
    @StateObject var userInfoViewModel: UserInfoViewModel = UserInfoViewModel()
    @StateObject var calendarViewModel: CalendarViewModel = CalendarViewModel()
    
    var body: some Scene {
        WindowGroup {
            if isLoading { InitView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, isLoading: $isLoading) }
            else         { MainView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel).environmentObject(AlertViewModel()) }
        }
    }
}
