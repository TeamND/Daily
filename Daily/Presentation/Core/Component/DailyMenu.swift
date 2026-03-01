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
            modifyGoal
            deleteGoal
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
                    Label("edit_goal".localized, systemImage: "pencil.line")
                }
            } else {
                Menu {
                    Button {
                        let data = GoalDataEntity(record: record, modifyType: .single)
                        let navigationObject = NavigationObject(viewType: .modify, data: data)
                        navigationEnvironment.navigate(navigationObject)
                        calendarViewModel.resetData()   // TODO: 삭제가 이루어지기 때문에 calendarViewModel data reset, 추후 수정
                    } label: {
                        Text("edit_this_only".localized)
                    }
                    Button {
                        let data = GoalDataEntity(record: record, modifyType: .all)
                        let navigationObject = NavigationObject(viewType: .modify, data: data)
                        navigationEnvironment.navigate(navigationObject)
                    } label: {
                        Text("edit_all".localized)
                    }
                } label: {
                    Label("edit_goal".localized, systemImage: "pencil.line")
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
                            alertEnvironment.showToast(alertType: NoticeAlert.removeNoticeTimeWithGoal)
                        }
                    )
                } label: {
                    Label("delete_goal".localized, systemImage: "trash")
                }
            } else {
                Menu {
                    Button {
                        calendarViewModel.deleteRecord(
                            record: record,
                            completeAction: {
                                alertEnvironment.showToast(alertType: NoticeAlert.removeNoticeTimeWithGoal)
                            }
                        )
                    } label: {
                        Text("delete_this_only".localized)
                    }
                    Menu {
                        Button {
                            calendarViewModel.deleteFutureRecords(
                                goal: goal,
                                completeAction: {
                                    alertEnvironment.showToast(alertType: NoticeAlert.removeNoticeTimeWithGoal)
                                }
                            )
                        } label: {
                            Text("delete_future_goals_only".localized)
                        }
                        Button {
                            calendarViewModel.deleteGoal(
                                goal: goal,
                                completeAction: {
                                    alertEnvironment.showToast(alertType: NoticeAlert.removeNoticeTimeWithGoal)
                                }
                            )
                        } label: {
                            Text("delete_with_past_records".localized)
                        }
                    } label: {
                        Text("delete_all".localized)
                    }
                } label: {
                    Label("delete_goal".localized, systemImage: "trash")
                }
            }
        }
    }
}
