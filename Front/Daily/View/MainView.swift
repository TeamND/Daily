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
            NavigationView {
                MainCalendar(calendar: calendar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            MainHeader(popupInfo: popupInfo)
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
