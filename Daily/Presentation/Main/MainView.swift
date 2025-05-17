//
//  MainView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    @AppStorage(UserDefaultKey.calendarType.rawValue) private var calendarType: String = ""
    
    var body: some View {
        NavigationStack(path: $navigationEnvironment.navigationPath) {
            CalendarYearView()
                .navigationDestination(for: NavigationObject.self) { navigationObject in
                    AnyView(navigationObject.dailyView()).navigationBarHidden(true)
                }
        }
        .onAppear {
            navigationEnvironment.navigateDirect(from: .year, to: CalendarTypes(rawValue: calendarType) ?? .month)
            PushNoticeManager.shared.setNoticeTouchAction(noticeTouchAction: goToday)
        }
        .onOpenURL { openUrl in
            guard let url = openUrl.absoluteString.removingPercentEncoding else { return }
            if url.contains("widget") { goToday() }
        }
    }
    
    private func goToday() {
        if let currentPage = navigationEnvironment.navigationPath.last, !currentPage.viewType.isCalendar { return }
        calendarViewModel.setDate(date: Date(format: .daily))
        navigationEnvironment.navigateDirect(from: .year)
    }
}

#Preview {
    MainView()
}
