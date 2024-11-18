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
    @StateObject var userInfoViewModel: UserInfoViewModel = UserInfoViewModel()
    @StateObject var calendarViewModel: CalendarViewModel = CalendarViewModel()
    
    @StateObject private var navigationEnvironment = NavigationEnvironment()
    @StateObject private var dailyCalendarViewModel = DailyCalendarViewModel()
    @StateObject var splashViewModel = SplashViewModel()
    
    var body: some Scene {
        WindowGroup {
            if userInfoViewModel.isNewVersion {
                ZStack {
                    if splashViewModel.isAppLaunching {
                        DailyMainView().environmentObject(navigationEnvironment).environmentObject(dailyCalendarViewModel)
                    }
                    if splashViewModel.isAppLoading {
                        SplashView(splashViewModel: splashViewModel)
                    }
                }
            } else {
                if isLoading { InitView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, isLoading: $isLoading) }
                else         { MainView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel).environmentObject(AlertViewModel()) }
            }
        }
    }
}
