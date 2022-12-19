//
//  RightSideMenu.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RightSideMenu: View {
    @StateObject var userInfo: UserInfo
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Rectangle()
                    .fill(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white, lineWidth: 12)
                    }
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        Button {
                            popupInfo.closePopup(isPopup: false)
                        } label: {
                            Label("닫기", systemImage: "x.circle")
                                .padding(12)
                        }
                    }
                    Text("기본 값 설정")
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                    CustomDivider(color: .gray, height: 1, hPadding: 12)
                    List {
                        let menus: [String] = ["언어", "일주일 시작 요일", "목표 수행일 선택 방식", "기본 달력"]
                        ForEach (menus, id: \.self) { menu in
                            MenuOnList(userInfo: userInfo, menu: menu)
                                .font(.system(size: 12))
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .frame(
                maxWidth: UIScreen.main.bounds.size.width - 100,
                maxHeight: .infinity
            )
        }
        .offset(x: popupInfo.showMenu ? 0 : UIScreen.main.bounds.size.width)
        .animation(.easeOut(duration: 0.4), value: popupInfo.showMenu)
    }
}
