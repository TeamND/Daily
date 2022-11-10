//
//  MainCalendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainCalendar: View {
    @Binding var calendar: Calendar
//    @StateObject var userInfo: UserInfo = UserInfo()
    @State var weeks: [String] = kWeeks[0]
    var body: some View {
        switch calendar.state {
        case "Year":
            Calendar_Year()
        case "Month":
            Calendar_Month(weeks: $weeks)
        default:
            Calendar_Week_Day()
        }
    }
}

struct MainCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MainCalendar(calendar: .constant(Calendar.sample[1]))
    }
}
