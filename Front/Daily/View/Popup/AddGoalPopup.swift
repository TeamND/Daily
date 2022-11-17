//
//  AddGoalPopup.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct AddGoalPopup: View {
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
                VStack(alignment: .leading, spacing: 12) {
                    GoalPrimeElementSetting()
                    Divider()
                    GoalDateOrRepeatSetting()
                    Divider()
                    GoalCountOrTimeSetting()
                    Divider()
                    ClosePopupHStack(popupInfo: popupInfo)
                    Spacer()
                }
                .padding(20)
            }
            .frame(
                width: UIScreen.main.bounds.size.width - 50,
                height: UIScreen.main.bounds.size.height - 150
            )
        }
        .scaleEffect(popupInfo.showPopup ? 1 : 0, anchor: .topTrailing)
        .animation(.easeOut(duration: 0.2), value: popupInfo.showPopup)
    }
}

struct AddGoalPopup_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalPopup(popupInfo: PopupInfo())
    }
}
