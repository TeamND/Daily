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
    
    var body: some View {
        ZStack {
            // leading
            HStack {
                if calendarViewModel.getCurrentState() == "month" {
                    Button {
                        calendarViewModel.setCurrentState(state: "year", year: 0, month: 0, day: 0, userInfoViewModel: userInfoViewModel)
                    } label: {
                        Label(calendarViewModel.getCurrentYearLabel(userInfoViewModel: userInfoViewModel), systemImage: "chevron.left")
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding(CGFloat.fontSize)
                }
                if calendarViewModel.getCurrentState() == "week" {
                    Button {
                        calendarViewModel.setCurrentState(state: "month", year: 0, month: 0, day: 0, userInfoViewModel: userInfoViewModel)
                    } label: {
                        Label(calendarViewModel.getCurrentMonthLabel(userInfoViewModel: userInfoViewModel), systemImage: "chevron.left")
                            .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                    }
                    .padding(CGFloat.fontSize)
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
                Button {
                    // 추후 동기화 작업이 필요
                    calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel, targetDate: Date())
                    calendarViewModel.setCurrentState(state: "week", year: Date().year, month: Date().month, day: Date().day, userInfoViewModel: userInfoViewModel)
                } label: {
                    HStack(spacing: CGFloat.fontSize / 2) {
                        Text("오늘")
                        Image(systemName: "chevron.right")
                    }
                    .padding(CGFloat.fontSize * 1.5)
                    .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                    .foregroundStyle(.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 1))
                }
                .tint(.primary)
                .accentColor(.primary)
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
