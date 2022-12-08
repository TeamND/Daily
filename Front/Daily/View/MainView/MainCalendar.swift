//
//  MainCalendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainCalendar: View {
    @StateObject var calendar: MyCalendar
    var body: some View {
        NavigationView {
            Calendar_Year(calendar: calendar)
                .navigationBarTitle("\(String(calendar.year))년")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
