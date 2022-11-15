//
//  RightSideMenu.swift
//  Daily
//
//  Created by 최승용 on 2022/11/15.
//

import SwiftUI

struct RightSideMenu: View {
    @StateObject var popupInfo: PopupInfo
    var body: some View {
        if popupInfo.showMenu {
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.white)
                        .edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Spacer()
                            Button {
                                popupInfo.closePopup(isPopup: false)
                            } label: {
                                Label("닫기", systemImage: "x.circle")
                            }
                        }
                        Text("기본 값 설정")
                            .font(.subheadline)
                        CustomDivider(color: .gray, height: 1)
                        VStack(spacing: 8) {
                            HStack {
                                Text("일주일 시작요일")
                                Spacer()
                                Button {
                                } label: {
                                    Text("일요일")
                                    Image(systemName: "chevron.right")
                                }
                            }
                            HStack {
                                Text("수행 일자 선택 방식")
                                Spacer()
                                Button {
                                } label: {
                                    Text("날짜")
                                    Image(systemName: "chevron.right")
                                }
                            }
                            HStack {
                                Text("알림 설정")
                                Spacer()
                                Button {
                                } label: {
                                    Text("On")
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                        .font(.caption)
                        Spacer()
                    }
                    .padding(12)
                }
                .frame(maxWidth: 300, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.4))
            .onTapGesture {
                popupInfo.closePopup(isPopup: false)
            }
        }
    }
}

struct RightSideMenu_Previews: PreviewProvider {
    static var previews: some View {
        RightSideMenu(popupInfo: PopupInfo())
    }
}
