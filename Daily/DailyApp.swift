//
//  DailyApp.swift
//  Daily
//
//  Created by 최승용 on 2022/10/31.
//

import SwiftUI
import SwiftData

import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        FirebaseApp.configure()

        return true
    }
}

@main
struct DailyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    @StateObject private var navigationEnvironment = NavigationEnvironment()
    @StateObject private var alertEnvironment = AlertEnvironment()
    @StateObject private var settingViewModel = SettingViewModel()
    @StateObject private var calendarViewModel = CalendarViewModel()
    @StateObject private var splashViewModel = SplashViewModel()
    
    @State private var sheetHeight: CGFloat = 0
    
    var body: some Scene {
        WindowGroup {
            daily
                .environmentObject(navigationEnvironment)
                .environmentObject(alertEnvironment)
                .environmentObject(settingViewModel)
                .environmentObject(calendarViewModel)
                .modelContainer(SwiftDataManager.shared.getContainer())
        }
    }
    
    private var daily: some View {
        ZStack {
            if splashViewModel.isMainReady { MainView() }
            SplashView(splashViewModel: splashViewModel)
            alertEnvironment.toastView
            alertEnvironment.alertView
        }
        .sheet(isPresented: Binding(
            get: { !splashViewModel.notices.isEmpty },
            set: { if !$0 { splashViewModel.notices.removeAll() } }
        )) { noticeSheet }
    }
    
    private var noticeSheet: some View {
        NoticeSheet(
            height: $sheetHeight,
            notice: splashViewModel.notices[0]  // FIXME: notices 전부를 보내도록 추후 수정(확장)
        )
        .presentationDetents([.height(sheetHeight)])
        .presentationDragIndicator(.visible)
    }
}
