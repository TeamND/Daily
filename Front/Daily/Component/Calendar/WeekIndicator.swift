//
//  WeekIndicator.swift
//  Daily
//
//  Created by 최승용 on 2022/11/17.
//

import SwiftUI

struct WeekIndicator: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    var tapPurpose: String = ""
    var body: some View {
        HStack(spacing: 0) {
            ForEach (userInfoViewModel.weeks.indices, id: \.self) { index in
                ZStack {
                    let isToday = userInfoViewModel.weeks[index] == calendarViewModel.getCurrentDOW(userInfoViewModel: userInfoViewModel)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                        .opacity(isToday && tapPurpose == "change" ? 1 : 0)
                        .padding(CGFloat.fontSize / 3)
                    Image(systemName: "circle.fill")
                        .font(.system(size: CGFloat.fontSize * 5))
                        .foregroundColor(Color("CustomColor").opacity(calendarViewModel.getDayOfRatingOnWeek(dayIndex: index)*0.8))
                        .padding([.horizontal], -6) // AddGoalPopup에서 width가 늘어나는 현상 때문에 추가
                    Text(userInfoViewModel.weeks[index])
                        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
                }
                .onTapGesture {
                    switch tapPurpose {
                    case "change":
                        calendarViewModel.changeCalendar(amount: index - calendarViewModel.getDOWIndex(userInfoViewModel: userInfoViewModel), userInfoViewModel: userInfoViewModel)
                    case "select":
                        if calendarViewModel.getDayOfRatingOnWeek(dayIndex: index) == 0 {
                            calendarViewModel.setDayOfRatingOnWeek(dayIndex: index, dayOfRating: 0.4)
                        } else {
                            calendarViewModel.setDayOfRatingOnWeek(dayIndex: index, dayOfRating: 0)
                        }
                    default:
                        break
                    }
                }
                .frame(width: CGFloat.dayOnMonthWidth)
            }
        }
        .frame(height: CGFloat.fontSize * 6)
        .frame(maxWidth: .infinity)
    }
}
