//
//  RecordList.swift
//  Daily
//
//  Created by 최승용 on 3/31/24.
//

import SwiftUI

struct RecordList: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
//            ForEach ($calendarViewModel.recordsOnWeek, id: \.self.uid) { record in
            ForEach (calendarViewModel.recordsOnWeek.indices, id: \.self) { index in
                let record = $calendarViewModel.recordsOnWeek[index]
                if false {
//                if record.is_set_time {
//                    if index == 0 || (index > 0 && calendarViewModel.recordsOnWeek[index - 1].set_time != record.set_time) {
                        TimeLine(record: record)
//                    }
                }
                RecordOnList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record)
                    .contextMenu {
                        NavigationLink {
                            ModifyDateView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record)
                        } label: {
                            Label("날짜 변경", systemImage: "calendar")
                        }
                        NavigationLink {
                            ModifyGoalView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record, modifyGoalModel: modifyGoalModel(record: record.wrappedValue))
                        } label: {
                            Label("목표 수정", systemImage: "pencil")
                        }
                        Button {
                            deleteGoal(goalUID: String(record.goal_uid.wrappedValue)) { data in
                                if data.code == "00" {
                                    calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
                                        if code == "99" { alertViewModel.showAlert() }
                                    }
                                } else { alertViewModel.showAlert() }
                            }
                        } label: {
                            Label("목표 삭제", systemImage: "trash")
                        }
                    }
                    .foregroundStyle(.primary)
            }
        }
    }
}
