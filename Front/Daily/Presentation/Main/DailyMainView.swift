//
//  DailyMainView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct DailyMainView: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var dailyCalendarViewModel: DailyCalendarViewModel
    @AppStorage(UserDefaultKey.calendarState.rawValue) var calendarState: String = ""
    
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
                            DailyGoalView()
                        case .modify:
                            let data = navigationObject.data as! ModifyDataModel
                            DailyModifyView(modifyData: data)
                        case .appInfo:
                            DailyAppInfoView()
                        }
                    }
                    .navigationBarHidden(true)
                }
        }
        .onAppear {
            if calendarState == CalendarType.month.rawValue || calendarState == CalendarType.day.rawValue {
                let navigationObject = NavigationObject(viewType: .calendarMonth)
                navigationEnvironment.navigate(navigationObject)
                if calendarState == CalendarType.day.rawValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let navigationObject = NavigationObject(viewType: .calendarDay)
                        navigationEnvironment.navigate(navigationObject)
                    }
                }
            }
        }
    }
}

#Preview {
    DailyMainView()
}
