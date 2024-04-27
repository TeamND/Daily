//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var isLoading: Bool = true
    @State var updateVersion: Bool = false
    @State var positionInViewPager = marginRange
    
    var body: some View {
        ZStack {
            if updateVersion {
                if isLoading {
                    Text("Loading...")
                } else {
                    VStack(spacing: 0) {
                        WeekIndicator(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, tapPurpose: "change")
                        CustomDivider(color: .primary, height: 2, hPadding: 12)
                        ViewPager(position: $positionInViewPager) {
                            ForEach(calendarViewModel.getCurrentMonth() - marginRange ... calendarViewModel.getCurrentMonth() + marginRange, id: \.self) { day in
                                VStack(spacing: 0) {
                                    if calendarViewModel.recordsOnWeek.count > 0 {
                                        ViewThatFits(in: .vertical) {
                                            RecordList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                                            ScrollView {
                                                RecordList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                                            }
                                        }
                                        .padding(.top, CGFloat.fontSize)
                                        Spacer()
                                    } else {
                                        NoRecord(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, updateVersion: updateVersion)
                                    }
                                }
                                .background(Color("ThemeColor"))
                            }
                        }
                    }
                    .onChange(of: positionInViewPager) { newValue in
                        print(newValue)
                        //                    if newValue == marginRange {
                        //                        return
                        //                    } else {
                        //                        calendarViewModel.getCurrentMonth() = newValue > marginRange ? calendarViewModel.getCurrentMonth() + 1 : calendarViewModel.getCurrentMonth() - 1
                        //                        positionInViewPager = marginRange
                        //                    }
                    }
                    .animation(.spring, value: positionInViewPager)
                }
            } else {
                VStack(spacing: 0) {
                    WeekIndicator(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, tapPurpose: "change")
                    CustomDivider(color: .primary, height: 2, hPadding: 12)
                    if calendarViewModel.recordsOnWeek.count > 0 {
                        ViewThatFits(in: .vertical) {
                            RecordList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                            ScrollView {
                                RecordList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel)
                            }
                        }
                        .padding(.top, CGFloat.fontSize)
                        .padding(.bottom, CGFloat.fontSize * 15)
                        Spacer()
                        // swipeAction 고민
                    } else {
                        NoRecord(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, updateVersion: updateVersion)
                    }
                }
                .background(Color("ThemeColor"))
            }
            if calendarViewModel.recordsOnWeek.count > 0 {
                AddGoalButton(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, updateVersion: updateVersion)
            }
        }
        .onAppear {
            getCalendarWeek(userID: String(userInfoViewModel.userInfo.uid), startDay: calendarViewModel.calcStartDay(value: -calendarViewModel.getDOWIndex(userInfoViewModel: userInfoViewModel))) { (data) in
                calendarViewModel.setRatingOnWeek(ratingOnWeek: data.data.rating)
            }
            getCalendarDay(userID: String(userInfoViewModel.userInfo.uid), day: "\(calendarViewModel.getCurrentYearStr())-\(calendarViewModel.getCurrentMonthStr())-\(calendarViewModel.getCurrentDayStr())") { (data) in
                calendarViewModel.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
                self.isLoading = false
            }
        }
        .onChange(of: calendarViewModel.currentDay) { day in
            getCalendarWeek(userID: String(userInfoViewModel.userInfo.uid), startDay: calendarViewModel.calcStartDay(value: -calendarViewModel.getDOWIndex(userInfoViewModel: userInfoViewModel))) { (data) in
                calendarViewModel.setRatingOnWeek(ratingOnWeek: data.data.rating)
            }
            getCalendarDay(userID: String(userInfoViewModel.userInfo.uid), day: "\(calendarViewModel.getCurrentYearStr())-\(calendarViewModel.getCurrentMonthStr())-\(calendarViewModel.getCurrentDayStr())") { (data) in
                calendarViewModel.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
            }
        }
    }
}
