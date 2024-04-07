//
//  RecordList.swift
//  Daily
//
//  Created by 최승용 on 3/31/24.
//

import SwiftUI

struct RecordList: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var navigationViewModel: NavigationViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var date: Date = Date()
    @State var isShowCalendarSheet: Bool = false
    
    var body: some View {
        VStack {
            ForEach ($calendarViewModel.recordsOnWeek, id:\.self.uid) { record in
                RecordOnList(userInfo: userInfo, calendarViewModel: calendarViewModel, record: record)
                    .contextMenu {
                        Button {
                            isShowCalendarSheet = true
                        } label: {
                            Label("Modify date of record", systemImage: "calendar")
                        }
                        NavigationLink {
                            RecordView(userInfo: userInfo, navigationViewModel: navigationViewModel, goalModel: GoalModel(recordModel: record.wrappedValue))
                        } label: {
                            Label("Modify goal", systemImage: "pencil")
                        }
                        Button {
                            deleteGoal(goalUID: String(record.goal_uid.wrappedValue)) { data in
                                if data.code == "00" {
                                    getCalendarWeek(userID: String(userInfo.uid), startDay: userInfo.calcStartDay(value: -userInfo.DOWIndex)) { (data) in
                                        calendarViewModel.setRatingOnWeek(ratingOnWeek: data.data.rating)
                                    }
                                    getCalendarDay(userID: String(userInfo.uid), day: "\(userInfo.currentYearStr)-\(userInfo.currentMonthStr)-\(userInfo.currentDayStr)") { (data) in
                                        calendarViewModel.setRecordsOnWeek(recordsOnWeek: data.data.goalList)
                                    }
                                } else { print("\(record.goal_uid) delete fail@@@") }
                            }
                        } label: {
                            Label("Delete goal", systemImage: "trash")
                        }
                    }
                    .sheet(isPresented: $isShowCalendarSheet) {
                        CalendarSheet(userInfo: userInfo, date: $date, recordUID: record.wrappedValue.uid)
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                    }
                    .foregroundStyle(.primary)
            }
        }
    }
}
