//
//  ClosePopupHStack.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct ClosePopupHStack: View {
    @StateObject var goal: Goal
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        HStack(spacing: 16) {
            Spacer()
            Button {
                popupInfo.closePopup(isPopup: true)
            } label: {
                Text("취소")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(RoundedRectangle(cornerRadius: 4).stroke())
            }
            Button {
//                goal.add()
                print("add")
                popupInfo.closePopup(isPopup: true)
            } label: {
                Text("저장")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(RoundedRectangle(cornerRadius: 4).stroke())
            }
        }
        .foregroundColor(.black)
    }
}
