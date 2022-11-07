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
                    Label("Calendar", systemImage: "calendar")
                }
            RecordTab()
                .tabItem {
                    Label("Record", systemImage: "checklist")
                }
            SettingTab()
                .tabItem {
                    Label("Setting", systemImage: "dial.high")
                }
        }
        .accentColor(.mint)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
