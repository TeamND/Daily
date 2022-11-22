//
//  MainCalendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainCalendar: View {
    @StateObject var calendar: Calendar
    var body: some View {
        NavigationView {
            Calendar_Year(calendar: calendar)
                .navigationBarTitle(YYYYformat.string(from: Date()))
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
