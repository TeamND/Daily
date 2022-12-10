//
//  MainView.swift
//  Daily
//
//  Created by 최승용 on 2022/11/05.
//

import SwiftUI

struct MainView: View {
    @State private var calendar: MyCalendar = MyCalendar()
    @State private var popupInfo: PopupInfo = PopupInfo()
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                MainHeader(calendar: calendar, popupInfo: popupInfo)
                    .frame(height: 40)
                MainCalendar(calendar: calendar)
            }
            Popup(popupInfo: popupInfo)
        }
        .accentColor(.mint)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
