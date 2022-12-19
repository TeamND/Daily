//
//  GoalDateOrRepeatSetting.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct GoalDateOrRepeatSetting: View {
    @StateObject var userInfo: UserInfo
    @State var dateOrRepeat: String = "날짜"
    var body: some View {
        Text("날짜 or 반복 설정")
            .font(.system(size: 20, weight: .bold))
        HStack {
            Picker("", selection: $dateOrRepeat) {
                ForEach(["날짜", "반복"], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(2)
            .cornerRadius(15)
        }
        .font(.system(size: 16))
        switch dateOrRepeat {
        case "날짜":
            MonthOnYear(userInfo: userInfo, month: userInfo.currentMonth, fontSize: 16, isTapSelect: true)
        case "반복":
            WeekIndicator(userInfo: userInfo, tapPurpose: "select")
        default:
            Text("")
        }
    }
}
