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
            ForEach (calendarViewModel.recordsOnWeek.indices, id: \.self) { index in
                let record = $calendarViewModel.recordsOnWeek[index]
                if record.is_set_time.wrappedValue {
                    if index == 0 ||    // 첫번째 항목일 경우 표기
                        (index > 0 &&   // n번째 항목일 경우
                         (calendarViewModel.recordsOnWeek[index - 1].is_set_time == false ||    // 이전 항목의 is_set_time이 false라면 set_time에 상관 없이 표기
                          calendarViewModel.recordsOnWeek[index - 1].set_time != record.set_time.wrappedValue)  // 이전 항목과 set_time이 다르면 표기
                        )
                    {
                        TimeLine(record: record)
                    }
                }
                RecordOnList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record)
                    .contextMenu {
                        NavigationLink {
                            ModifyDateView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record)
                        } label: {
                            Label("날짜 변경", systemImage: "calendar")
                        }
                        if record.cycle_type.wrappedValue == "repeat" {
                            Menu {
                                Button {
                                    print("Comming soon !!!")
                                } label: {
                                    Text("단일 수정 (공사 중 🚧)")
                                        .foregroundStyle(.gray)
                                }
                                .disabled(true)
                                NavigationLink {
                                    ModifyGoalView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record, modifyGoalModel: modifyGoalModel(record: record.wrappedValue))
                                } label: {
                                    Text("일괄 수정")
                                }
                            } label: {
                                Label("목표 수정", systemImage: "pencil")
                            }
                            Menu {
                                Button {
                                    // remove Record
                                    removeRecord(recordUID: String(record.uid.wrappedValue)) { data in
                                        if data.code == "00" {
                                            calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
                                                if code == "99" { alertViewModel.showAlert() }
                                            }
                                        } else { alertViewModel.showAlert() }
                                    }
                                } label: {
                                    Text("단일 삭제")
                                }
                                Menu {
                                    Button {
                                        removeRecordAll(goalUID: String(record.goal_uid.wrappedValue)) { data in
                                            if data.code == "00" {
                                                calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
                                                    if code == "99" { alertViewModel.showAlert() }
                                                }
                                            } else { alertViewModel.showAlert() }
                                        }
                                    } label: {
                                        Text("오늘 이후의 목표만 삭제")
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
                                        Text("과거의 기록도 함께 삭제")
                                    }
                                } label: {
                                    Text("일괄 삭제")
                                }
                            } label: {
                                Label("목표 삭제", systemImage: "trash")
                            }
                        } else {
                            NavigationLink {
                                ModifyGoalView(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: record, modifyGoalModel: modifyGoalModel(record: record.wrappedValue))
                            } label: {
                                Label("목표 수정", systemImage: "pencil")
                            }
                            Button {
                                // remove Record로 수정(?)
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
                    }
                    .foregroundStyle(.primary)
            }
        }
    }
}
