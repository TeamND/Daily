//
//  ShowMenuButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct ShowMenuButton: View {
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        Button {
            popupInfo.showPopup(isPopup: false)
        } label: {
            VStack {
                Image(systemName: "slider.horizontal.3")
                Text("menu")
                    .font(.system(size: 12))
            }
            .padding(8)
        }
    }
}
