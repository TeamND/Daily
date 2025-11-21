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
            PushNoticeManager.shared.setNoticeTouchAction { goCalendar(date: $0) }
        }
        .onOpenURL { openUrl in
            guard let url = openUrl.absoluteString.removingPercentEncoding,
                  let urlComponents = URLComponents(url: openUrl, resolvingAgainstBaseURL: false),
                  let familyString = urlComponents.queryItems?.first(where: { $0.name == "family" })?.value,
                  let familyRaw = Int(familyString),
                  let family = WidgetFamily(rawValue: familyRaw) else { return }
            
            if url.contains("widget") { goCalendar(to: family == .systemLarge ? .month : .day) }
        }
    }
    
    private func goCalendar(to: CalendarTypes = .day, date: Date? = nil) {
        let from = navigationEnvironment.navigationPath.last?.viewType.calendarType ?? .year
        navigationEnvironment.navigateDirect(from: from, to: to)
        calendarViewModel.setDate(date: date ?? Date(format: .daily))
    }
}

#Preview {
    MainView()
}
