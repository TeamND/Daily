//
//  MainView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI
import WidgetKit

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
            PushNoticeManager.shared.setNoticeTouchAction { goToday() }
        }
        .onOpenURL { openUrl in
            guard let url = openUrl.absoluteString.removingPercentEncoding,
                  let urlComponents = URLComponents(url: openUrl, resolvingAgainstBaseURL: false),
                  let familyString = urlComponents.queryItems?.first(where: { $0.name == "family" })?.value,
                  let familyRaw = Int(familyString),
                  let family = WidgetFamily(rawValue: familyRaw) else { return }
            
            if url.contains("widget") { goToday(to: family == .systemLarge ? .month : .day) }
        }
    }
    
    private func goToday(to: CalendarTypes = .day) {
        if let currentPage = navigationEnvironment.navigationPath.last, !currentPage.viewType.isCalendar { return }
        
        let currentPage = navigationEnvironment.navigationPath.last
        let from: CalendarTypes = currentPage == nil ? .year : currentPage!.viewType == .calendarMonth ? .month : .day
        print("from is \(from.rawValue), to is \(to.rawValue)")
        calendarViewModel.setDate(date: Date(format: .daily))
        navigationEnvironment.navigateDirect(from: from, to: to)
    }
}

#Preview {
    MainView()
}
