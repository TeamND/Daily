//
//  CalendarHeader.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

struct CalendarHeader: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Namespace var NS
    
    var body: some View {
        ZStack {
            // leading
            HStack {
                if calendarViewModel.getCurrentState() == "month" {
                    Button {
                        withAnimation {
                            calendarViewModel.setCurrentState(state: "year", year: 0, month: 0, day: 0, userInfoViewModel: userInfoViewModel)
                        }
                    } label: {
                        Label(calendarViewModel.getCurrentYearLabel(userInfoViewModel: userInfoViewModel), systemImage: "chevron.left")
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding(CGFloat.fontSize)
                    .matchedGeometryEffect(id: "year", in: NS)
                }
                if calendarViewModel.getCurrentState() == "week" {
                    Button {
                        withAnimation {
                            calendarViewModel.setCurrentState(state: "month", year: 0, month: 0, day: 0, userInfoViewModel: userInfoViewModel)
                        }
                    } label: {
                        Label(calendarViewModel.getCurrentMonthLabel(userInfoViewModel: userInfoViewModel), systemImage: "chevron.left")
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
                    calendarViewModel.changeCalendar(amount: -1, userInfoViewModel: userInfoViewModel)
                } label: {
                    Image(systemName: "chevron.left")
                }
                if calendarViewModel.getCurrentState() == "year" {
                    Menu {
                        ForEach(calendarViewModel.getCurrentYear() - 5 ... calendarViewModel.getCurrentYear() + 5, id: \.self) { year in
                            Button {
                                calendarViewModel.changeCalendar(amount: year - calendarViewModel.getCurrentYear(), userInfoViewModel: userInfoViewModel)
                            } label: {
                                Text("\(String(year)) 년")
                            }
                        }
                    } label: {
                        Text(calendarViewModel.getCurrentYearLabel(userInfoViewModel: userInfoViewModel))
                            .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .matchedGeometryEffect(id: "year", in: NS)
                }
                if calendarViewModel.getCurrentState() == "month" {
                    Menu {
                        ForEach(1 ... 12, id:\.self) { month in
                            Button {
                                calendarViewModel.changeCalendar(amount: month - calendarViewModel.getCurrentMonth(), userInfoViewModel: userInfoViewModel)
                            } label: {
                                Text("\(String(month)) 월")
                            }
                        }
                    } label: {
                        Text(calendarViewModel.getCurrentMonthLabel(userInfoViewModel: userInfoViewModel))
                            .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .matchedGeometryEffect(id: "month", in: NS)
                }
                if calendarViewModel.getCurrentState() == "week" {
                    Menu {
                        ForEach(1 ... calendarViewModel.lengthOfMonth(), id:\.self) { day in
                            Button {
                                calendarViewModel.changeCalendar(amount: day - calendarViewModel.getCurrentDay(), userInfoViewModel: userInfoViewModel)
                            } label: {
                                Text("\(String(day)) 일")
                            }
                        }
                    } label: {
                        Text(calendarViewModel.getCurrentDayLabel(userInfoViewModel: userInfoViewModel))
                            .font(.system(size: CGFloat.fontSize * 3, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .matchedGeometryEffect(id: "week", in: NS)
                }
                Button {
                    calendarViewModel.changeCalendar(amount: 1, userInfoViewModel: userInfoViewModel)
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
