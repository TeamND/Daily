//
//  MainView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    @AppStorage(UserDefaultKey.calendarType.rawValue) private var calendarType: String = ""
    
    var body: some View {
        NavigationStack(path: $navigationEnvironment.navigationPath) {
            CalendarYearView()
                .navigationDestination(for: NavigationObject.self) { navigationObject in
                    AnyView(navigationObject.dailyView()).navigationBarHidden(true)
                }
        }
        .onAppear { navigationEnvironment.navigateDirect(from: .year, to: CalendarType(rawValue: calendarType) ?? .month) }
        .onOpenURL { openUrl in
            guard let url = openUrl.absoluteString.removingPercentEncoding else { return }
            if url.contains("widget") { navigationEnvironment.navigateDirect(from: .year) }
        }
    }
}

#Preview {
    MainView()
}
