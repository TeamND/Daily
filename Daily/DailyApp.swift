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
    @StateObject private var calendarViewModel = CalendarViewModel()
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
                .environmentObject(calendarViewModel)
                .modelContainer(dailyModelContainer)
        }
    }
    
    private var daily: some View {
        ZStack {
            MainView()
            if splashViewModel.isAppLoading {
                SplashView(splashViewModel: splashViewModel)
            }
            alertEnvironment.toastView
        }
        .alert(isPresented: $alertEnvironment.isShowAlert) {
            Alert(
                title: Text("알림 설정이 꺼져있어, 일부 기능이 제한된 상태에요 😱"),
                message: Text("Daily의 알림을 받아보세요 🙌🙌"),
                primaryButton: .default(
                    Text("설정으로 이동"),
                    action: {
                        System().openSettingApp()
                    }
                ),
                secondaryButton: .destructive(
                    Text("다음에 하기")
                )
            )
        }
    }
}
