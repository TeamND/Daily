//
//  PopupDim.swift
//  Daily
//
//  Created by 최승용 on 2022/11/16.
//

import SwiftUI

struct PopupDim: View {
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        let showDim = popupInfo.showMenu || popupInfo.showPopup
        Rectangle()
            .fill(.black.opacity(0.4))
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                let isPopup: Bool = popupInfo.showPopup
                popupInfo.closePopup(isPopup: isPopup)
            }
            .opacity(showDim ? 1.0 : 0.0)
            .animation(.easeOut, value: showDim)
    }
}
