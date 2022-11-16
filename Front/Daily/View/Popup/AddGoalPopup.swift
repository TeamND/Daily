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
                VStack {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    Button {
                        popupInfo.closePopup(isPopup: true)
                    } label: {
                        Text("Dismiss Button")
                    }
                    Spacer()
                }
                .padding(20)
            }
            .frame(
                width: UIScreen.main.bounds.size.width - 50,
                height: UIScreen.main.bounds.size.height - 150
            )
        }
        .offset(y: popupInfo.showPopup ? 0 : UIScreen.main.bounds.size.height)
        .animation(.easeOut(duration: 0.4), value: popupInfo.showPopup)
    }
}

struct AddGoalPopup_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalPopup(popupInfo: PopupInfo())
    }
}
