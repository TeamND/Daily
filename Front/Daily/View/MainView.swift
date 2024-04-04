//
//  MainView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @StateObject var calendarViewModel: CalendarViewModel = CalendarViewModel()
    @StateObject var tabViewModel: TabViewModel = TabViewModel()
    
    var body: some View {
        TabView (selection: $tabViewModel.tagIndex) {
            CalendarView(userInfo: userInfo, userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, tabViewModel: tabViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(0)
            RecordView(userInfo: userInfo, tabViewModel: tabViewModel)
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Record")
                }
                .tag(1)
            AppInfoView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("AppInfo")
                }
                .tag(2)
        }
        .accentColor(Color("CustomColor"))
        .mainViewDragGesture(userInfo: userInfo, calendarViewModel: calendarViewModel, tabViewModel: tabViewModel)
    }
}

#Preview {
    MainView(userInfo: UserInfo(), userInfoViewModel: UserInfoViewModel())
}
