//
//  MainView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI
import WidgetKit

import FirebaseAnalytics

struct MainView: View {
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    @EnvironmentObject private var settingViewModel: SettingViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack(path: $navigationEnvironment.navigationPath) {
            CalendarYearView()
                .navigationDestination(for: NavigationObject.self) { navigationObject in
                    AnyView(navigationObject.dailyView()).navigationBarHidden(true)
                }
                .id(settingViewModel.language)
        }
        .onAppear {
            AnalyticsManager.shared.log(.openApp)

            navigationEnvironment.navigateDirect(from: .year, to: settingViewModel.calendarType)
            PushNoticeManager.shared.setNoticeTouchAction {
                AnalyticsManager.shared.log(.openFromNotification)
                goCalendar(date: $0)
            }
        }
        .onOpenURL { openUrl in
            guard let url = openUrl.absoluteString.removingPercentEncoding,
                  let urlComponents = URLComponents(url: openUrl, resolvingAgainstBaseURL: false),
                  let familyString = urlComponents.queryItems?.first(where: { $0.name == "family" })?.value,
                  let familyRaw = Int(familyString),
                  let family = WidgetFamily(rawValue: familyRaw) else { return }
            
            if url.contains("widget") {
                AnalyticsManager.shared.log(.openFromWidget)
                goCalendar(to: family == .systemLarge ? .month : .day)
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                AnalyticsManager.shared.log(.enterAppBackground)
            }
        }
    }
    
    private func goCalendar(to: CalendarTypes = .day, date: Date? = nil) {
        guard let from = navigationEnvironment.navigationPath.isEmpty
                ? .year
                : navigationEnvironment.navigationPath.last?.viewType.calendarType else { return }
        navigationEnvironment.navigateDirect(from: from, to: to)
        calendarViewModel.setDate(date: date ?? Date(format: .daily))
    }
}

#Preview {
    MainView()
}
