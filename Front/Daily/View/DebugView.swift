//
//  DebugView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct DebugView: View {
    @StateObject var userInfo: UserInfo = UserInfo(uid: -1, set_startday: 0, set_language: "korea", set_dateorrepeat: "date", set_calendarstate: "month")
    @State var tagIndex = 0
    
    var body: some View {
        TabView (selection: $tagIndex) {
            CalendarView(userInfo: userInfo)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(0)
            RecordView(userInfo: userInfo)
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
