//
//  CalendarYearView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct CalendarYearView: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @ObservedObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        Text("test String is \(dailyCalendarViewModel.test)")
        Button {
            let navigationObject = NavigationObject(viewType: .calendarMonth)
            navigationEnvironment.navigationPath.append(navigationObject)
        } label: {
            Text("go month")
        }
        Button {
            let navigationObject = NavigationObject(viewType: .calendarDay)
            navigationEnvironment.navigationPath.append(navigationObject)
        } label: {
            Text("go day")
        }
        .onAppear {
            print("year onAppear")
        }
    }
}

#Preview {
    CalendarYearView(dailyCalendarViewModel: DailyCalendarViewModel())
}
