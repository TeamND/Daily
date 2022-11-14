//
//  MainCalendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainCalendar: View {
    @StateObject var calendar: Calendar
    @State var weeks: [String] = kWeeks[0]
    var body: some View {
        switch calendar.state {
        case "Year":
            Calendar_Year(calendar: calendar)
        case "Month":
            Calendar_Month(calendar: calendar, weeks: $weeks)
        default:
            Calendar_Week_Day()
        }
    }
}

struct MainCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MainCalendar(calendar: Calendar())
    }
}
