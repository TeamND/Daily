//
//  MainHeader.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainHeader: View {
    @StateObject var calendar: Calendar
    var body: some View {
        HStack {
            HStack {
                if calendar.naviLabel != "" { GoPrevButton(calendar: calendar) }
            }
            .frame(width: 150, alignment: .leading)
            Spacer()
            Text(calendar.naviTitle)
                .frame(maxWidth: .infinity)
            Spacer()
            HStack {
                AddGoalButton()
                    .frame(width: 40)
                ShowMenuButton()
                    .frame(width: 40)
            }
            .frame(width: 150, alignment: .trailing)
        }
        .font(.headline)
        .padding(8)
    }
}

struct MainHeader_Previews: PreviewProvider {
    static var previews: some View {
        MainHeader(calendar: Calendar())
            .previewLayout(.fixed(width: 500, height: 40))
    }
}