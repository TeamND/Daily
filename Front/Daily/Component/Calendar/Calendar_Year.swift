//
//  Calendar_Year.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Year: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var updateVersion: Bool = false
    @State var positionInViewPager = marginRange
    
    var body: some View {
        ZStack {
            if updateVersion {
                VStack(spacing: 0) {
                    CustomDivider(color: .primary, height: 2)
                        .padding(12)
                    ViewPager(position: $positionInViewPager) {
                        ForEach(calendarViewModel.currentYear - marginRange ... calendarViewModel.currentYear + marginRange, id: \.self) { year in
                            VStack (spacing: 0) {
                                ForEach (0..<4) { rowIndex in
                                    HStack(spacing: 0) {
                                        ForEach (0..<3) { colIndex in
                                            let month = (rowIndex * 3) + colIndex + 1
                                            NavigationLink(value: "month_\(month)") {
                                                MonthOnYear(userInfo: userInfo, calendarViewModel: calendarViewModel, month: month)
                                            }
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .background(Color("ThemeColor"))
                        }
                    }
                }
                .onChange(of: positionInViewPager) { newValue in
                    print(newValue)
                    if 0 < newValue && newValue < marginRange * 2 {
                        return
                    } else {
                        calendarViewModel.setCurrentYear(year: calendarViewModel.getCurrentYear() + newValue - marginRange)
                        positionInViewPager = marginRange
                    }
                }
                .animation(.spring, value: positionInViewPager)
            } else {
                VStack(spacing: 0) {
                    CustomDivider(color: .primary, height: 2)
                        .padding(12)
                    ForEach (0..<4) { rowIndex in
                        HStack(spacing: 0) {
                            ForEach (0..<3) { colIndex in
                                let month = (rowIndex * 3) + colIndex + 1
                                Button {
                                    withAnimation {
                                        userInfo.currentMonth = month
                                        userInfo.currentState = "month"
                                    }
                                } label: {
                                    MonthOnYear(userInfo: userInfo, calendarViewModel: calendarViewModel, month: month)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .background(Color("ThemeColor"))
            }
            AddGoalButton(userInfo: userInfo, updateVersion: updateVersion)
        }
        .onAppear {
            getCalendarYear(userID: String(userInfo.uid), year: userInfo.currentYearStr) { (data) in
                calendarViewModel.setRatingOnYear(ratingOnYear: data.data)
            }
        }
        .onChange(of: userInfo.currentYear) { year in
            getCalendarYear(userID: String(userInfo.uid), year: userInfo.currentYearStr) { (data) in
                calendarViewModel.setRatingOnYear(ratingOnYear: data.data)
            }
        }
    }
}


#Preview {
    Calendar_Year(userInfo: UserInfo(), calendarViewModel: CalendarViewModel())
}
