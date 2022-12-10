//
//  MainHeader.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct MainHeader: View {
    @StateObject var calendar: MyCalendar
    @StateObject var popupInfo: PopupInfo
    @Namespace var NS
    var body: some View {
        ZStack {
            HStack {
                if calendar.state == "Month" {
                    Button {
                        withAnimation {
                            calendar.state = "Year"
                        }
                    } label: {
                        Label("\(String(calendar.year))년", systemImage: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .padding(8)
                    .matchedGeometryEffect(id: "Year", in: NS)
                }
                if calendar.state == "Week&Day" {
                    Button {
                        withAnimation {
                            calendar.state = "Month"
                        }
                    } label: {
                        Label("\(calendar.month)월", systemImage: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .padding(8)
                    .matchedGeometryEffect(id: "Month", in: NS)
                }
                Spacer()
            }
            HStack {
                Spacer()
                if calendar.state == "Year" {
                    Text("\(String(calendar.year))년")
                        .font(.system(size: 20, weight: .bold))
                        .matchedGeometryEffect(id: "Year", in: NS)
                }
                if calendar.state == "Month" {
                    Text("\(calendar.month)월")
                        .font(.system(size: 20, weight: .bold))
                        .matchedGeometryEffect(id: "Month", in: NS)
                }
                if calendar.state == "Week&Day" {
                    Text("\(calendar.startDay + calendar.dayIndex)일")
                        .font(.system(size: 20, weight: .bold))
                        .matchedGeometryEffect(id: "Week&Day", in: NS)
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
