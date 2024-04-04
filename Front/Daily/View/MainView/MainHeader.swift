//
//  MainHeader.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainHeader: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var tabViewModel: TabViewModel
    @StateObject var popupInfo: PopupInfo
    @Namespace var NS
    var body: some View {
        ZStack {
            // leading
            HStack {
                if userInfo.currentState == "month" {
                    Button {
                        withAnimation {
                            userInfo.currentState = "year"
                        }
                    } label: {
                        Label(userInfo.currentYearLabel, systemImage: "chevron.left")
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
                        Label(userInfo.currentMonthLabel, systemImage: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .padding(8)
                    .matchedGeometryEffect(id: "month", in: NS)
                }
                Spacer()
            }
            // center
            HStack {
                Spacer()
                Button {
                    userInfo.changeCalendar(direction: "prev", calendarViewModel: calendarViewModel)
                } label: {
                    Image(systemName: "chevron.left")
                }
                if userInfo.currentState == "year" {
                    Text(userInfo.currentYearLabel)
                        .font(.system(size: 20, weight: .bold))
                        .matchedGeometryEffect(id: "year", in: NS)
                }
                if userInfo.currentState == "month" {
                    Text(userInfo.currentMonthLabel)
                        .font(.system(size: 20, weight: .bold))
                        .matchedGeometryEffect(id: "month", in: NS)
                }
                if userInfo.currentState == "week" {
                    Text(userInfo.currentDayLabel)
                        .font(.system(size: 20, weight: .bold))
                        .matchedGeometryEffect(id: "week", in: NS)
                }
                Button {
                    userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel)
                } label: {
                    Image(systemName: "chevron.right")
                }
                Spacer()
            }
            // trailing
            HStack(spacing: 0) {
                Spacer()
                Button {
                    tabViewModel.setTagIndex(tagIndex: 1)
                } label: {
                    VStack {
                        Image(systemName: "plus")
                        Text("Add")
                            .font(.system(size: 12))
                    }
                }
                .padding(8)
            }
//            HStack(spacing: 0) {
//                Spacer()
//                Button {
//                    popupInfo.showPopup(isPopup: true)
//                } label: {
//                    VStack {
//                        Image(systemName: "plus")
//                        Text("add")
//                            .font(.system(size: 12))
//                    }
//                }
//                .padding(8)
//                Button {
//                    popupInfo.showPopup(isPopup: false)
//                } label: {
//                    VStack {
//                        Image(systemName: "slider.horizontal.3")
//                        Text("menu")
//                            .font(.system(size: 12))
//                    }
//                }
//                .padding(8)
//            }
        }
    }
}
