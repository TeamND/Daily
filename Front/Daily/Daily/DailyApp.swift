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
    @StateObject private var alertViewModel = AlertViewModel()
    @StateObject private var loadingViewModel = LoadingViewModel()
    @StateObject var splashViewModel = SplashViewModel()
    
    var body: some Scene {
        WindowGroup {
            if userInfoViewModel.isNewVersion {
                daily
                    .environmentObject(navigationEnvironment)
                    .environmentObject(dailyCalendarViewModel)
                    .environmentObject(alertViewModel)
                    .environmentObject(loadingViewModel)
            } else {
                if isLoading { InitView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, isLoading: $isLoading) }
                else         { MainView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel).environmentObject(AlertViewModel()) }
            }
        }
    }
    
    private var daily: some View {
        ZStack {
//            TestView()
            if splashViewModel.isAppLaunching {
                DailyMainView()
            }
            if splashViewModel.isAppLoading {
                SplashView(splashViewModel: splashViewModel)
            }
            alertViewModel.toastView
            if loadingViewModel.isLoading { loadingViewModel.loadingView }
        }
    }
}
