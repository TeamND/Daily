//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var navigationViewModel: NavigationViewModel
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
                        WeekIndicator(userInfo: userInfo, calendarViewModel: calendarViewModel, tapPurpose: "change")
                        CustomDivider(color: .primary, height: 2, hPadding: 12)
                        ViewPager(position: $positionInViewPager) {
                            ForEach(calendarViewModel.currentMonth - marginRange ... calendarViewModel.currentMonth + marginRange, id: \.self) { day in
                                VStack(spacing: 0) {
                                    if calendarViewModel.recordsOnWeek.count > 0 {
                                        ViewThatFits(in: .vertical) {
                                            RecordList(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel)
                                            ScrollView {
                                                RecordList(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel)
                                            }
                                        }
                                        .padding(.top, CGFloat.fontSize)
                                        Spacer()
                                    } else {
                                        NoRecord(userInfo: userInfo, navigationViewModel: navigationViewModel, updateVersion: updateVersion)
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
                        //                        calendarViewModel.currentMonth = newValue > marginRange ? calendarViewModel.currentMonth + 1 : calendarViewModel.currentMonth - 1
                        //                        positionInViewPager = marginRange
                        //                    }
                    }
                    .animation(.spring, value: positionInViewPager)
                    if calendarViewModel.recordsOnWeek.count > 0 {
                        AddGoalButton(userInfo: userInfo, navigationViewModel: navigationViewModel)
                    }
                }
            } else {
                VStack(spacing: 0) {
                    WeekIndicator(userInfo: userInfo, calendarViewModel: calendarViewModel, tapPurpose: "change")
                    CustomDivider(color: .primary, height: 2, hPadding: 12)
                    if calendarViewModel.recordsOnWeek.count > 0 {
                        ViewThatFits(in: .vertical) {
                            RecordList(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel)
                            ScrollView {
                                RecordList(userInfo: userInfo, calendarViewModel: calendarViewModel, navigationViewModel: navigationViewModel)
                            }
                        }
                        .padding(.top, CGFloat.fontSize)
                        Spacer()
                        // swipeAction 재정리 이후 수정
                        //                List {
                        //                    ForEach ($calendarViewModel.recordsOnWeek, id:\.self.uid) { record in
                        //                        RecordOnList(userInfo: userInfo, calendarViewModel: calendarViewModel, record: record)
                        //                            .swipeActions(allowsFullSwipe: true) {
                        //                                Button(role: .destructive) {
                        //                                    deleteGoal(goalUID: String(record.goal_uid.wrappedValue)) { data in
                        //                                        if data.code == "00" {
                        //                                            getCalendarWeek(userID: String(userInfo.uid), startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)) { (data) in
                        //                                                calendarViewModel.setRatingOnWeek(ratingOnWeek: data.data.rating)
                        //                                            }
                        //                                            getCalendarDay(userID: String(userInfo.uid), day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)") { (data) in
                        //                                                calendarViewModel.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
                        //                                            }
                        //                                        } else { print("\(record.goal_uid) delete fail@@@") }
                        //                                    }
                        //                                } label: {
                        //                                    Label("Delete", systemImage: "trash")
                        //                                }
                        //                                //                                Button() {
                        //                                //                                    print("modify")
                        //                                //                                } label: {
                        //                                //                                    Label("Modify", systemImage: "pencil")
                        //                                //                                }
                        //                                //                                .tint(.orange)
                        //                            }
                        //                            .frame(minHeight: 40)
                        //                    }
                        //                }
                        //                .listStyle(.plain)
                        //                .listRowSeparator(.hidden)
                    } else {
                        NoRecord(userInfo: userInfo, navigationViewModel: navigationViewModel, updateVersion: updateVersion)
                    }
                }
            }
        }
        .onAppear {
            getCalendarWeek(userID: String(userInfo.uid), startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)) { (data) in
                calendarViewModel.setRatingOnWeek(ratingOnWeek: data.data.rating)
            }
            getCalendarDay(userID: String(userInfo.uid), day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)") { (data) in
                calendarViewModel.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
                self.isLoading = false
            }
        }
        .onChange(of: userInfo.currentDay) { day in
            getCalendarWeek(userID: String(userInfo.uid), startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)) { (data) in
                calendarViewModel.setRatingOnWeek(ratingOnWeek: data.data.rating)
            }
            getCalendarDay(userID: String(userInfo.uid), day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)") { (data) in
                calendarViewModel.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
            }
        }
    }
}
