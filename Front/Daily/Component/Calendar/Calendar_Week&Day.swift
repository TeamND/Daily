//
//  Calendar_Week&Day.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Week_Day: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var navigationViewModel: NavigationViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    var body: some View {
        VStack {
            WeekIndicator(userInfo: userInfo, calendarViewModel: calendarViewModel, tapPurpose: "change")
            CustomDivider(color: .primary, height: 2, hPadding: 12)
            if calendarViewModel.recordsOnWeek.count > 0 {
                ViewThatFits(in: .vertical) {
                    RecordList(userInfo: userInfo, navigationViewModel: navigationViewModel, calendarViewModel: calendarViewModel)
                    ScrollView {
                        RecordList(userInfo: userInfo, navigationViewModel: navigationViewModel, calendarViewModel: calendarViewModel)
                    }
                }
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
                NoRecord(userInfo: userInfo, navigationViewModel: navigationViewModel)
            }
        }
        .onAppear {
            getCalendarWeek(userID: String(userInfo.uid), startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)) { (data) in
                calendarViewModel.setRatingOnWeek(ratingOnWeek: data.data.rating)
            }
            getCalendarDay(userID: String(userInfo.uid), day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)") { (data) in
                calendarViewModel.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
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
