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
        if calendar.state == "Year" { Calendar_Year(calendar: calendar) }
        if calendar.state == "Month" { Calendar_Month(calendar: calendar) }
        if calendar.state == "Week&Day" { Calendar_Week_Day() }
    }
}
