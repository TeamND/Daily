//
//  MainView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/05.
//

import SwiftUI

struct MainView: View {
    @State private var calendar: Calendar = Calendar()
    @State private var popupInfo: PopupInfo = PopupInfo()
    var body: some View {
        ZStack {
            VStack {
                MainHeader(calendar: calendar, popupInfo: popupInfo)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                MainCalendar(calendar: calendar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            AddGoalPopup(popupInfo: popupInfo)
            RightSideMenu(popupInfo: popupInfo)
        }
        .accentColor(.mint)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
