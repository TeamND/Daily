//
//  CalendarDayView.swift
//  Daily
//
//  Created by seungyooooong on 10/21/24.
//

import SwiftUI

struct CalendarDayView: View {
    @ObservedObject var dailyCalendarViewModel: DailyCalendarViewModel
    
    var body: some View {
        Button {
            dailyCalendarViewModel.printTest()
        } label: {
            Text("day")
        }
    }
}

#Preview {
    CalendarDayView(dailyCalendarViewModel: DailyCalendarViewModel())
}
