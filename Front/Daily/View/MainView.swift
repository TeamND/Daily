//
//  MainView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userInfo: UserInfo
    @StateObject var tabViewModel: TabViewModel = TabViewModel()
    
    var body: some View {
        TabView (selection: $tabViewModel.tagIndex) {
            CalendarView(userInfo: userInfo, tabViewModel: tabViewModel)
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
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.width > 100 {
                    if tabViewModel.tagIndex == 0 && value.startLocation.x > 30 {
                        userInfo.changeCalendar(direction: "prev")
                    } else {
                        tabViewModel.setTagIndex(tagIndex: (tabViewModel.tagIndex+2)%3)
                    }
                }
                if value.translation.width < -100 {
                    if tabViewModel.tagIndex == 0 && value.startLocation.x < CGFloat.screenWidth-30 {
                        userInfo.changeCalendar(direction: "next")
                    } else {
                        tabViewModel.setTagIndex(tagIndex: (tabViewModel.tagIndex+1)%3)
                    }
                }
            }
        )
    }
}

#Preview {
    MainView(userInfo: UserInfo())
}
