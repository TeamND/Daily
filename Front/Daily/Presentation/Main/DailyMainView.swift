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
                        case .goal:
                            DailyGoalView()
                        }
                    }
                    .navigationBarHidden(true)
                }
        }
        .onAppear {
            print("DailyMainView onAppear")
        }
    }
}

#Preview {
    DailyMainView()
}
