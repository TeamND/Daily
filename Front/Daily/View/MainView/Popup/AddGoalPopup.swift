//
//  AddGoalPopup.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct AddGoalPopup: View {
    @StateObject var userInfo: UserInfo
    @StateObject var popupInfo: PopupInfo
    @StateObject var goal: Goal
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.background)
                VStack(alignment: .leading, spacing: 12) {
                    GoalPrimeElementSetting(goal: goal)
                    Divider()
                    GoalCountOrTimeSetting(goal: goal)
                    Divider()
                    GoalDateOrRepeatSetting(userInfo: userInfo, goal: goal)
                    Divider()
                    ClosePopupHStack(userInfo: userInfo, popupInfo: popupInfo, goal: goal)
                    Spacer()
                }
                .padding(20)
            }
            .frame(
                width: UIScreen.main.bounds.size.width - 50,
                height: UIScreen.main.bounds.size.height - 150
            )
        }
        .opacity(popupInfo.showPopup ? 1.0 : 0.0)
        .scaleEffect(popupInfo.showPopup ? 1 : 0.1, anchor: .topTrailing)
        .animation(.easeOut(duration: 0.2), value: popupInfo.showPopup)
    }
}
