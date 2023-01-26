//
//  ClosePopupHStack.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct ClosePopupHStack: View {
    @StateObject var userInfo: UserInfo
    @StateObject var popupInfo: PopupInfo
    @StateObject var goal: Goal
    var body: some View {
        HStack(spacing: 16) {
            Spacer()
            Button {
                goal.reset(cycle_type: userInfo.set_dateorrepeat)
                popupInfo.closePopup(isPopup: true)
            } label: {
                Text("취소")
                    .foregroundColor(.primary)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(RoundedRectangle(cornerRadius: 4).stroke().foregroundColor(.primary))
            }
            Button {
                goal.add(user_uid: goal.user_uid)
                print("add")
                popupInfo.closePopup(isPopup: true)
            } label: {
                Text("저장")
                    .foregroundColor(.primary)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(RoundedRectangle(cornerRadius: 4).stroke().foregroundColor(.primary))
            }
        }
        .foregroundColor(.black)
    }
}
