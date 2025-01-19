//
//  RecordList.swift
//  Daily
//
//  Created by seungyooooong on 11/29/24.
//

import SwiftUI
import SwiftData

// MARK: - RecordList
struct RecordList: View {
    let date: Date
    let records: [DailyRecordModel]
    
    init(date: Date, records: [DailyRecordModel]) {
        self.date = date
        self.records = records.sorted {
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.isSetTime != nextGoal.isSetTime {
                return !prevGoal.isSetTime && nextGoal.isSetTime
            }
            if let prevGoal = $0.goal, let nextGoal = $1.goal, prevGoal.setTime != nextGoal.setTime {
                return prevGoal.setTime < nextGoal.setTime
            }
            return $0.date < $1.date
        }
    }
    
    var body: some View {
        VStack {
            let processedRecords = records.reduce(into: [(record: DailyRecordModel, showTimeline: Bool)]()) { result, record in
                let prevGoal = result.last?.record.goal
                let showTimeline = record.goal.map { goal in
                    if goal.isSetTime { return prevGoal.map { !$0.isSetTime || $0.setTime != goal.setTime } ?? true }
                    return false
                } ?? false
                result.append((record, showTimeline))
            }
            ForEach(processedRecords, id: \.record.id) { processed in
                let record = processed.record
                if let goal = record.goal {
                    if processed.showTimeline { DailyTimeLine(setTime: goal.setTime) }
                    DailyRecord(record: record)
                        .contextMenu { DailyMenu(record: record, date: date) }
                }
            }
        }
    }
}

// MARK: - DailyMenu
struct DailyMenu: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    let record: DailyRecordModel
    let date: Date
    
    init(record: DailyRecordModel, date: Date) {
        self.record = record
        self.date = date
    }

    var body: some View {
        if let goal = record.goal {
            VStack {
                // MARK: Notice
                if goal.isSetTime {
                    if record.notice == nil {
                        let notice = 5  // TODO: 추후 세분화
                        Button {
                            PushNoticeManager.shared.addNotice(
                                id: String(describing: record.id),
                                content: goal.content,
                                date: record.date,
                                setTime: goal.setTime,
                                notice: notice
                            )
                            record.notice = notice
                            try? modelContext.save()
                            alertEnvironment.showToast(message: "\(notice)분 전에 알려드릴게요! 💬")
                        } label: {
                            Label("\(notice)분 전 알리기", systemImage: "clock.badge")
                        }
                        .disabled(Date() > CalendarServices.shared.noticeDate(date: record.date, setTime: goal.setTime, notice: notice) ?? Date())
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
                // MARK: ModifyGoal
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
                // MARK: DeleteGoal
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
}

// MARK: - DailyRecord
struct DailyRecord: View {
    let record: DailyRecordModel
    let isButtonDisabled: Bool
    
    init(record: DailyRecordModel, isButtonDisabled: Bool = false) {
        self.record = record
        self.isButtonDisabled = isButtonDisabled
    }
    
    var body: some View {
        if let goal = record.goal {
            HStack(spacing: 12) {
                Image(systemName: "\(goal.symbol.imageName)\(record.isSuccess ? ".fill" : "")")
                Text(goal.content)
                Spacer()
                RecordButton(record: record, color: isButtonDisabled ? Colors.reverse : Colors.daily)
                    .frame(maxHeight: 40)
                    .disabled(isButtonDisabled)
            }
            .frame(height: 60)
            .overlay {
                let recordCount = goal.type == .timer ? record.count.timerFormat() : String(record.count)
                let goalCount = goal.type == .timer ? goal.count.timerFormat() : String(goal.count)
                Text("\(recordCount) / \(goalCount)")
                    .font(.system(size : CGFloat.fontSize * 2))
                    .padding(.top, CGFloat.fontSize)
                    .padding(.trailing, 40)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            .padding(.horizontal, CGFloat.fontSize * 2)
            .foregroundStyle(Colors.reverse)
            .background {
                RoundedRectangle(cornerRadius: 15).fill(Colors.background)
            }
            .padding(.horizontal, CGFloat.fontSize / 2)
        }
    }
}

// MARK: - NoRecord
struct NoRecord: View {
    @EnvironmentObject var navigationEnvironment: NavigationEnvironment
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            Text(noRecordText)
            Button {
                let data = GoalDataModel(date: calendarViewModel.currentDate)
                let navigationObject = NavigationObject(viewType: .goal, data: data)
                navigationEnvironment.navigate(navigationObject)
            } label: {
                Text(goRecordViewText)
                    .foregroundStyle(Colors.daily)
            }
        }
        .padding()
        .padding(.bottom, CGFloat.screenHeight * 0.25)
        .font(.system(size: CGFloat.fontSize * 2.5, weight: .bold))
    }
}
