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
            MainCalendar(userInfo: userInfo, tabViewModel: tabViewModel)
        }
    }
}

#Preview {
    CalendarView(userInfo: UserInfo(), tabViewModel: TabViewModel())
}
