//
//  AddGoalButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/07.
//

import SwiftUI

struct AddGoalButton: View {
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        Button {
            popupInfo.showPopup(isPopup: true)
        } label: {
            VStack {
                Image(systemName: "plus")
                Text("add")
                    .font(.system(size: 12))
            }
            .padding(8)
        }
    }
}
