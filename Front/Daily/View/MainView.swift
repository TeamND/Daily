//
//  MainView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/05.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            CalendarTab()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            RecordTab()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Record")
                }
            SettingTab()
                .tabItem {
                    Image(systemName: "dial.high")
                    Text("Setting")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
