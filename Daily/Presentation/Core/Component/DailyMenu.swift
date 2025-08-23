//
//  DailyMenu.swift
//  Daily
//
//  Created by seungyooooong on 1/20/25.
//

import SwiftUI

// MARK: - DailyMenu
struct DailyMenu: View {
    @EnvironmentObject private var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject private var alertEnvironment: AlertEnvironment
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    let record: DailyRecordModel
    let goal: DailyGoalModel
    
    init(record: DailyRecordModel) {
        self.record = record
        self.goal = record.goal!
    }

    var body: some View {
        VStack {
            notice
            modifyGoal
            deleteGoal
        }
    }
    
    // MARK: Notice
    private var notice: some View {
        Group {
            if goal.isSetTime {
                if record.notice == nil {
                    Menu {
                        ForEach(NoticeTimes.allCases, id: \.self) { noticeTime in
                            Button {
                                calendarViewModel.addNotice(
                                    goal: goal, record: record, noticeTime: noticeTime,
                                    completeAction: {
                                        alertEnvironment.showToast(message: "설정한 시간 \(noticeTime.text) 전에 알려드릴게요")
                                    }
                                )
                            } label: {
                                Text("\(noticeTime.text) 전")
                            }
                            .disabled(Date() > CalendarServices.shared.noticeDate(date: record.date, setTime: goal.setTime, notice: noticeTime.rawValue) ?? Date())
                        }
                    } label: {
                        Label("알림 켜기", systemImage: "clock.badge")
                    }
                } else {
                    Button {
                        calendarViewModel.removeNotice(
                            record: record,
                            completeAction: {
                                alertEnvironment.showToast(message: "알림이 삭제되었어요")
                            }
                        )
                    } label: {
                        Label("알림 끄기", systemImage: "clock.badge.fill")
                    }
                }
            }
        }
    }
    
    // MARK: ModifyGoal
    private var modifyGoal: some View {
        Group {
            if goal.cycleType == .date {
                Button {
                    let data = GoalDataEntity(record: record, modifyType: .record)
                    let navigationObject = NavigationObject(viewType: .modify, data: data)
                    navigationEnvironment.navigate(navigationObject)
                } label: {
                    Label("목표 수정", systemImage: "pencil.line")
                }
            } else {
                Menu {
                    Button {
                        let data = GoalDataEntity(record: record, modifyType: .single)
                        let navigationObject = NavigationObject(viewType: .modify, data: data)
                        navigationEnvironment.navigate(navigationObject)
                        calendarViewModel.resetData()   // TODO: 삭제가 이루어지기 때문에 calendarViewModel data reset, 추후 수정
                    } label: {
                        Text("단일 수정")
                    }
                    Button {
                        let data = GoalDataEntity(record: record, modifyType: .all)
                        let navigationObject = NavigationObject(viewType: .modify, data: data)
                        navigationEnvironment.navigate(navigationObject)
                    } label: {
                        Text("일괄 수정")
                    }
                } label: {
                    Label("목표 수정", systemImage: "pencil.line")
                }
            }
        }
    }
    
    // MARK: DeleteGoal
    private var deleteGoal: some View {
        Group {
            if goal.cycleType == .date {
                Button {
                    calendarViewModel.deleteGoal(
                        goal: goal,
                        completeAction: {
                            alertEnvironment.showToast(message: "알림이 함께 삭제되었어요")
                        }
                    )
                } label: {
                    Label("목표 삭제", systemImage: "trash")
                }
            } else {
                Menu {
                    Button {
                        calendarViewModel.deleteRecord(
                            record: record,
                            completeAction: {
                                alertEnvironment.showToast(message: "알림이 함께 삭제되었어요")
                            }
                        )
                    } label: {
                        Text("단일 삭제")
                    }
                    Menu {
                        Button {
                            calendarViewModel.deleteRecords(
                                goal: goal,
                                completeAction: {
                                    alertEnvironment.showToast(message: "알림이 함께 삭제되었어요")
                                }
                            )
                        } label: {
                            Text("오늘 이후의 목표만 삭제")
                        }
                        Button {
                            calendarViewModel.deleteGoal(
                                goal: goal,
                                completeAction: {
                                    alertEnvironment.showToast(message: "알림이 함께 삭제되었어요")
                                }
                            )
                        } label: {
                            Text("과거의 기록도 함께 삭제")
                        }
                    } label: {
                        Text("일괄 삭제")
                    }
                } label: {
                    Label("목표 삭제", systemImage: "trash")
                }
            }
        }
    }
}
