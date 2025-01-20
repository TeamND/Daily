//
//  DailyMenu.swift
//  Daily
//
//  Created by seungyooooong on 1/20/25.
//

import SwiftUI
import SwiftData

// MARK: - DailyMenu
struct DailyMenu: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    let record: DailyRecordModel
    let goal: DailyGoalModel
    let date: Date
    
    init(record: DailyRecordModel, date: Date) {
        self.record = record
        self.goal = record.goal!
        self.date = date
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
                                PushNoticeManager.shared.addNotice(
                                    id: String(describing: record.id),
                                    content: goal.content,
                                    date: record.date,
                                    setTime: goal.setTime,
                                    noticeTime: noticeTime
                                )
                                record.notice = noticeTime.rawValue
                                try? modelContext.save()
                                alertEnvironment.showToast(message: "\(noticeTime.text) 전에 알려드릴게요! 💬")
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
                        PushNoticeManager.shared.removeNotice(id: String(describing: record.id))
                        record.notice = nil
                        try? modelContext.save()
                        alertEnvironment.showToast(message: "알림이 삭제되었어요 🫥")
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
            if goal.cycleType == .date || goal.parentGoal != nil {
                Button {
                    let data = ModifyDataModel(date: date, modifyRecord: record, modifyType: .record)
                    let navigationObject = NavigationObject(viewType: .modify, data: data)
                    navigationEnvironment.navigate(navigationObject)
                } label: {
                    Label("목표 수정", systemImage: "pencil.line")
                }
            } else {
                Menu {
                    Button {
                        let data = ModifyDataModel(date: date, modifyRecord: record, modifyType: .single)
                        let navigationObject = NavigationObject(viewType: .modify, data: data)
                        navigationEnvironment.navigate(navigationObject)
                    } label: {
                        Text("단일 수정")
                    }
                    Button {
                        let data = ModifyDataModel(date: date, modifyRecord: record, modifyType: .all)
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
                    if record.notice != nil {
                        PushNoticeManager.shared.removeNotice(id: String(describing: record.id))
                        alertEnvironment.showToast(message: "알림이 함께 삭제되었어요 🫥")
                    }
                    modelContext.delete(goal)
                    try? modelContext.save()
                } label: {
                    Label("목표 삭제", systemImage: "trash")
                }
            } else {
                Menu {
                    Button {
                        if record.notice != nil {
                            PushNoticeManager.shared.removeNotice(id: String(describing: record.id))
                            alertEnvironment.showToast(message: "알림이 함께 삭제되었어요 🫥")
                        }
                        modelContext.delete(record)
                        try? modelContext.save()
                    } label: {
                        Text("단일 삭제")
                    }
                    Menu {
                        Button {
                            guard let totalRecords = try? modelContext.fetch(FetchDescriptor<DailyRecordModel>()) else { return }
                            let deleteRecords = totalRecords.filter { currentRecord in
                                guard let currentGoal = currentRecord.goal else { return false }
                                return currentGoal.parentGoal?.id ?? currentGoal.id == goal.id && currentRecord.date > Date(format: .daily)
                            }
                            deleteRecords.forEach {
                                if $0.notice != nil {
                                    PushNoticeManager.shared.removeNotice(id: String(describing: $0.id))
                                    alertEnvironment.showToast(message: "알림이 함께 삭제되었어요 🫥")
                                }
                                modelContext.delete($0)
                            }
                            try? modelContext.save()
                        } label: {
                            Text("오늘 이후의 목표만 삭제")
                        }
                        Button {
                            goal.records.forEach {
                                if $0.notice != nil {
                                    PushNoticeManager.shared.removeNotice(id: String(describing: $0.id))
                                    alertEnvironment.showToast(message: "알림이 함께 삭제되었어요 🫥")
                                }
                            }
                            goal.childGoals.forEach { modelContext.delete($0) }
                            modelContext.delete(goal)
                            try? modelContext.save()
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
