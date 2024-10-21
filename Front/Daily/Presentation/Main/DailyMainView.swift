//
//  DailyMainView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct DailyMainView: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @StateObject var dailyCalendarViewModel: DailyCalendarViewModel = DailyCalendarViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationEnvironment.navigationPath) {
            CalendarYearView(dailyCalendarViewModel: dailyCalendarViewModel)
                .navigationDestination(for: NavigationObject.self) { navigationObject in
                    Group {
                        switch navigationObject.viewType {
                        case .calendarMonth:
                            CalendarMonthView(dailyCalendarViewModel: dailyCalendarViewModel)
                        case .calendarDay:
                            CalendarDayView(dailyCalendarViewModel: dailyCalendarViewModel)
                        }
                    }
//                    .navigationBarHidden(true)
                }
        }
        .onAppear {
            print("test")
            let navigationObject = NavigationObject(viewType: .calendarMonth)
            navigationEnvironment.navigationPath.append(navigationObject)
        }
    }
}

#Preview {
    DailyMainView()
}
