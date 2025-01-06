//
//  DailyApp.swift
//  Daily
//
//  Created by 최승용 on 2022/10/31.
//

import SwiftUI
import SwiftData
import DailyUtilities

@main
struct DailyApp: App {
    @StateObject private var alertEnvironment = AlertEnvironment()
    @StateObject private var navigationEnvironment = NavigationEnvironment()
    @StateObject private var dailyCalendarViewModel = DailyCalendarViewModel()
    @StateObject var splashViewModel = SplashViewModel()
    
    let dailyModelContainer: ModelContainer
    
    init() {
        dailyModelContainer = try! ModelContainer(
            for: DailyGoalModel.self, DailyRecordModel.self,
            configurations: ModelConfiguration(url: FileManager.sharedContainerURL())
        )
    }
    
    var body: some Scene {
        WindowGroup {
            daily
                .environmentObject(alertEnvironment)
                .environmentObject(navigationEnvironment)
                .environmentObject(dailyCalendarViewModel)
                .modelContainer(dailyModelContainer)
        }
    }
    
    private var daily: some View {
        ZStack {
            DailyMainView()
            if splashViewModel.isAppLoading {
                SplashView(splashViewModel: splashViewModel)
            }
            alertEnvironment.toastView
        }
    }
}
