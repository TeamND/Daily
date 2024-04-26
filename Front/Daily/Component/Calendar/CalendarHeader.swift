//
//  CalendarHeader.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct CalendarHeader: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var navigationViewModel: NavigationViewModel
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
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding(CGFloat.fontSize)
                    .matchedGeometryEffect(id: "year", in: NS)
                }
                if userInfo.currentState == "week" {
                    Button {
                        withAnimation {
                            userInfo.currentState = "month"
                        }
                    } label: {
                        Label(userInfo.currentMonthLabel, systemImage: "chevron.left")
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding(CGFloat.fontSize)
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
                    Menu {
                        ForEach(Date().year - 5 ... Date().year + 5, id: \.self) { year in
                            Button {
                                userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel, amount: year - userInfo.currentYear)
                            } label: {
                                Text("\(String(year)) 년")
                            }
                        }
                    } label: {
                        Text(userInfo.currentYearLabel)
                            .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .matchedGeometryEffect(id: "year", in: NS)
                }
                if userInfo.currentState == "month" {
                    Menu {
                        ForEach(1 ... 12, id:\.self) { month in
                            Button {
                                userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel, amount: month - userInfo.currentMonth)
                            } label: {
                                Text("\(String(month)) 월")
                            }
                        }
                    } label: {
                        Text(userInfo.currentMonthLabel)
                            .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .matchedGeometryEffect(id: "month", in: NS)
                }
                if userInfo.currentState == "week" {
                    Menu {
                        ForEach(1 ... userInfo.lengthOfMonth(), id:\.self) { day in
                            Button {
                                userInfo.changeCalendar(direction: "next", calendarViewModel: calendarViewModel, amount: day - userInfo.currentDay)
                            } label: {
                                Text("\(String(day)) 일")
                            }
                        }
                    } label: {
                        Text(userInfo.currentDayLabel)
                            .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                            .foregroundColor(.primary)
                    }
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
                NavigationLink {
                    AppInfoView()
                } label: {
                    Image(systemName: "info.circle").font(.system(size: CGFloat.fontSize * 2.5))
                }
                .padding(CGFloat.fontSize * 2)
            }
        }
    }
}
