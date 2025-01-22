//
//  MainView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @AppStorage(UserDefaultKey.calendarType.rawValue) var calendarType: String = ""
    
    var body: some View {
        NavigationStack(path: $navigationEnvironment.navigationPath) {
            CalendarYearView()
                .navigationDestination(for: NavigationObject.self) { navigationObject in
                    Group {
                        switch navigationObject.viewType {
                        case .calendarMonth:
                            CalendarMonthView()
                        case .calendarDay:
                            CalendarDayView()
                        case .goal:
                            let data = navigationObject.data as! GoalDataModel
                            GoalView(goalData: data)
                        case .modify:
                            let data = navigationObject.data as! ModifyDataModel
                            ModifyView(modifyData: data)
                        case .appInfo:
                            AppInfoView()
                        }
                    }
                    .navigationBarHidden(true)
                }
        }
        .onAppear {
            if calendarType == CalendarType.month.rawValue || calendarType == CalendarType.day.rawValue {
                navigationEnvironment.navigate(NavigationObject(viewType: .calendarMonth))
                if calendarType == CalendarType.day.rawValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        navigationEnvironment.navigate(NavigationObject(viewType: .calendarDay))
                    }
                }
            }
        }
        .onOpenURL { openUrl in
            let url = openUrl.absoluteString.removingPercentEncoding ?? ""
            if url.contains("widget") {
                navigationEnvironment.navigate(NavigationObject(viewType: .calendarMonth))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    navigationEnvironment.navigate(NavigationObject(viewType: .calendarDay))
                }
            }
        }
    }
}

#Preview {
    MainView()
}
