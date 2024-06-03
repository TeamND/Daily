//
//  RecordList.swift
//  Daily
//
//  Created by 최승용 on 3/31/24.
//

import SwiftUI

struct RecordList: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            ForEach ($calendarViewModel.recordsOnWeek, id: \.self.uid) { record in
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
                                    calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel)
                                } else { print("\(record.goal_uid) delete fail@@@") }
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
