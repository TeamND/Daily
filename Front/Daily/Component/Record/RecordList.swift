//
//  RecordList.swift
//  Daily
//
//  Created by 최승용 on 3/31/24.
//

import SwiftUI

struct RecordList: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            ForEach ($calendarViewModel.recordsOnWeek, id:\.self.uid) { record in
                RecordOnList(userInfo: userInfo, calendarViewModel: calendarViewModel, record: record)
                    .contextMenu {
                        // 추후 수정 버튼 추가
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
            }
        }
    }
}
