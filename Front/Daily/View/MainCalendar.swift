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
        switch calendar.state {
        case "Year":
            Calendar_Year(calendar: calendar)
        case "Month":
            Calendar_Month(calendar: calendar)
        default:
            Calendar_Week_Day(calendar: calendar)
        }
    }
}

struct MainCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MainCalendar(calendar: Calendar())
    }
}
