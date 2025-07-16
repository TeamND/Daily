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
    
    private let dailyModelContainer: ModelContainer
    
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
                .environmentObject(calendarViewModel)
                .modelContainer(dailyModelContainer)
        }
    }
    
    private var daily: some View {
        ZStack {
            MainView()
            SplashView()
            alertEnvironment.toastView
            alertEnvironment.alertView
        }
    }
}
