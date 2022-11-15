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
        if popupInfo.showPopup {
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
                    }
                }
                .frame(width: 300, height: 700)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.4))
            .onTapGesture {
                popupInfo.closePopup(isPopup: true)
            }
        }
    }
}

struct AddGoalPopup_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalPopup(popupInfo: PopupInfo())
    }
}
