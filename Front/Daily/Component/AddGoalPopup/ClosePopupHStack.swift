//
//  ClosePopupHStack.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct ClosePopupHStack: View {
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        HStack(spacing: 16) {
            Spacer()
            Button {
                popupInfo.closePopup(isPopup: true)
            } label: {
                Text("취소")
                    .padding([.top, .bottom], 4)
                    .padding([.leading, .trailing], 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke()
                    }
            }
            Button {
                popupInfo.closePopup(isPopup: true)
            } label: {
                Text("저장")
                    .padding([.top, .bottom], 4)
                    .padding([.leading, .trailing], 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke()
                    }
            }
        }
        .foregroundColor(.black)
    }
}

struct ClosePopupHStack_Previews: PreviewProvider {
    static var previews: some View {
        ClosePopupHStack(popupInfo: PopupInfo())
    }
}