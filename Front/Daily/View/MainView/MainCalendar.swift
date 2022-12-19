//
//  MainCalendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainCalendar: View {
    @StateObject var userInfo: UserInfo
    var body: some View {
        if userInfo.currentState == "year" { Calendar_Year(userInfo: userInfo) }
        if userInfo.currentState == "month" { Calendar_Month(userInfo: userInfo) }
        if userInfo.currentState == "week" { Calendar_Week_Day(userInfo: userInfo) }
    }
}
