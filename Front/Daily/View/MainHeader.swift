//
//  MainHeader.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainHeader: View {
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                AddGoalButton(popupInfo: popupInfo)
                ShowMenuButton(popupInfo: popupInfo)
            }
            .frame(maxHeight: 40)
            Spacer()
        }
    }
}
