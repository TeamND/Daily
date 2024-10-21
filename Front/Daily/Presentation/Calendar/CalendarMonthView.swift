//
//  CalendarMonthView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct CalendarMonthView: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @ObservedObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        Button {
            dailyCalendarViewModel.printTest()
        } label: {
            Text("month")
        }
        Button {
            dailyCalendarViewModel.changeTest()
        } label: {
            Text("changeTest")
        }
        Button {
            let navigationObject = NavigationObject(viewType: .calendarDay)
            navigationEnvironment.navigationPath.append(navigationObject)
        } label: {
            Text("go day")
        }
//        TabView(selection: $currentCalendar) {
//            ForEach(-10 ... 10, id: \.self) { year in
//                ForEach(1 ... 12, id: \.self) { month in
//                    let tag = String(2024 + year) + "-" + String(month)
//                    dailyCalendarView(currentCalendar)
//                        .onAppear {
//                            dailyCalendarViewModel.onAppear(tag)
//                        }
//                        .tag(tag)
//                }
//            }
//        }
//        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            print("month onAppear")
        }
    }
}

#Preview {
    CalendarMonthView(dailyCalendarViewModel: DailyCalendarViewModel())
}
