//
//  DailyApp.swift
//  Daily
//
//  Created by 최승용 on 2022/10/31.
//

import SwiftUI
import SwiftData

@main
struct DailyApp: App {
    @StateObject private var navigationEnvironment = NavigationEnvironment()
    @StateObject private var alertEnvironment = AlertEnvironment()
    @StateObject private var calendarViewModel = CalendarViewModel()
    @StateObject private var splashViewModel = SplashViewModel()
    
    @State private var sheetHeight: CGFloat = 0
    
    var body: some Scene {
        WindowGroup {
            daily
                .environmentObject(alertEnvironment)
                .environmentObject(navigationEnvironment)
                .environmentObject(calendarViewModel)
                .modelContainer(SwiftDataManager.shared.container)
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
