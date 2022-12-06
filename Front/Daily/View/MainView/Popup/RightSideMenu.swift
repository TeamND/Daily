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
        Menu(isSelected: false, title: "언어", selectedOption: "한국어"),
        Menu(isSelected: false, title: "일주일 시작 요일", selectedOption: "일요일"),
        Menu(isSelected: false, title: "목표 수행일 선택 방식", selectedOption: "날짜")
    ]
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
                        .font(.subheadline)
                        .padding()
                    CustomDivider(color: .gray, height: 1, hPadding: 12)
                    List {
                        ForEach (menuList.indices, id: \.self) { index in
                            MenuOnList(menu: menuList[index], index: index)
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
