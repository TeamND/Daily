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
              Text("The First Tab")
                .tabItem {
                  Image(systemName: "calendar")
                  Text("Calendar")
                }
              Text("Another Tab")
                .tabItem {
                  Image(systemName: "checklist")
                  Text("Record")
                }
              Text("The Last Tab")
                .tabItem {
                  Image(systemName: "dial.high")
                  Text("Setting")
                }
//                .badge(10)
            }
            .font(.headline)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
