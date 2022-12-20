//
//  MainHeader.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainHeader: View {
    @StateObject var userInfo: UserInfo
    @StateObject var popupInfo: PopupInfo
    @Namespace var NS
    var body: some View {
        ZStack {
            HStack {
                if userInfo.currentState == "month" {
                    Button {
                        withAnimation {
                            userInfo.currentState = "year"
                        }
                    } label: {
                        Label("\(String(userInfo.currentYear))년", systemImage: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .padding(8)
                    .matchedGeometryEffect(id: "year", in: NS)
                }
                if userInfo.currentState == "week" {
                    Button {
                        withAnimation {
                            userInfo.currentState = "month"
                        }
                    } label: {
                        Label("\(userInfo.currentMonth)월", systemImage: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .padding(8)
                    .matchedGeometryEffect(id: "month", in: NS)
                }
                Spacer()
            }
            HStack {
                Spacer()
                if userInfo.currentState == "year" {
                    Text("\(String(userInfo.currentYear))년")
                        .font(.system(size: 20, weight: .bold))
                        .matchedGeometryEffect(id: "year", in: NS)
                }
                if userInfo.currentState == "month" {
                    Text("\(userInfo.currentMonth)월")
                        .font(.system(size: 20, weight: .bold))
                        .matchedGeometryEffect(id: "month", in: NS)
                }
                if userInfo.currentState == "week" {
                    Text("\(userInfo.currentDay)일")
                        .font(.system(size: 20, weight: .bold))
                        .matchedGeometryEffect(id: "week", in: NS)
                }
                Spacer()
            }
            HStack(spacing: 0) {
                Spacer()
                Button {
                    popupInfo.showPopup(isPopup: true)
                } label: {
                    VStack {
                        Image(systemName: "plus")
                        Text("add")
                            .font(.system(size: 12))
                    }
                }
                .padding(8)
                Button {
                    popupInfo.showPopup(isPopup: false)
                } label: {
                    VStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("menu")
                            .font(.system(size: 12))
                    }
                }
                .padding(8)
            }
        }
    }
}
