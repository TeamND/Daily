//
//  RightSideMenu.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RightSideMenu: View {
    @StateObject var popupInfo: PopupInfo
    @State var menuList: [Menu] = [
        Menu(isSelected: false, title: "일주일 시작요일", selectedOption: "일요일"),
        Menu(isSelected: false, title: "수행 일자 선택 방식", selectedOption: "날짜"),
        Menu(isSelected: false, title: "알림 설정", selectedOption: "On")
    ]
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
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
                        .font(.subheadline)
                        .padding()
                    CustomDivider(color: .gray, height: 1, hPadding: 12)
                    List {
                        ForEach (menuList) { menu in
                            MenuOnList(menu: menu)
                                .font(.caption)
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
