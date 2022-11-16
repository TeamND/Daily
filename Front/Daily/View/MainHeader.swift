//
//  MainHeader.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainHeader: View {
    @StateObject var calendar: Calendar
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        HStack {
            HStack {
                if calendar.naviLabel != "" { GoPrevButton(calendar: calendar) }
            }
            .frame(width: UIScreen.main.bounds.size.width / 3, alignment: .leading)
            Spacer()
            Text(calendar.naviTitle)
                .frame(maxWidth: .infinity)
            Spacer()
            HStack {
                AddGoalButton(popupInfo: popupInfo)
                    .frame(width: 40)
                ShowMenuButton(popupInfo: popupInfo)
                    .frame(width: 40)
            }
            .frame(width: UIScreen.main.bounds.size.width / 3, alignment: .trailing)
        }
        .font(.system(size: 20, weight: .bold))
        .padding(8)
    }
}

struct MainHeader_Previews: PreviewProvider {
    static var previews: some View {
        MainHeader(calendar: Calendar(), popupInfo: PopupInfo())
            .previewLayout(.fixed(width: 500, height: 40))
    }
}
