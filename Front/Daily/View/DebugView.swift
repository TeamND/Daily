//
//  DebugView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct DebugView: View {
    @StateObject var userInfo: UserInfo = UserInfo()
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
    }
}

#Preview {
    DebugView()
}
