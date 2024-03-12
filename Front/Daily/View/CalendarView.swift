//
//  CalendarView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var tabViewModel: TabViewModel
    @State private var popupInfo: PopupInfo = PopupInfo()
    
    var body: some View {
        VStack(spacing: 0) {
            MainHeader(userInfo: userInfo, popupInfo: popupInfo, tabViewModel: tabViewModel, isDebugMode: true)
                .frame(height: 40)
            if userInfo.currentState == "year" { Calendar_Year(userInfo: userInfo) }
            if userInfo.currentState == "month" { Calendar_Month(userInfo: userInfo) }
            if userInfo.currentState == "week" { Calendar_Week_Day(userInfo: userInfo) }
        }
    }
}

#Preview {
    CalendarView(userInfo: UserInfo(), tabViewModel: TabViewModel())
}
