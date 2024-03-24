//
//  MainCalendar.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainCalendar: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var tabViewModel: TabViewModel
    var body: some View {
        if userInfo.currentState == "year" { Calendar_Year(userInfo: userInfo) }
        if userInfo.currentState == "month" { Calendar_Month(userInfo: userInfo) }
        if userInfo.currentState == "week" { Calendar_Week_Day(userInfo: userInfo, tabViewModel: tabViewModel) }
    }
}
