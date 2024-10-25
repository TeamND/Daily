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
                    switch navigationObject.viewType {
                    case .calendarMonth:
                        CalendarMonthView(dailyCalendarViewModel: dailyCalendarViewModel)
                            .navigationBarHidden(true)
                    case .calendarDay:
                        CalendarDayView(dailyCalendarViewModel: dailyCalendarViewModel)
                            .navigationBarHidden(true)
                    case .record:
                        RecordView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
                    }
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
